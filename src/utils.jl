# utils.jl to be included into Inolap.jl

using Downloads

function download_data(pars)
  my_name="download_data"
  (;verb,datadir,url) = pars

  err(x) = error("download_data -> $(x)\n")

  verb>0 && (println();@info "-->start of $(my_name)")
  #!isdir(datadir) && err("bad or missing datadir")
  !isdir(datadir) && mkpath(datadir)
  tname=split(url,"/")[end]
  tpath=joinpath(datadir,tname)
  if !isfile(tpath)
    verb>0 && (@info "   start --> $(tname)")
    Downloads.download(url, tpath)
    verb>0 && (@info "   <-- end")
  else
    verb>0 && (@info "   $(tname) --> previous instance")
  end
  verb>0 && (@info "<-- end of $(my_name)")

  pars.comm["tpath"]=tpath
end


# got the 
#<?> time tar xzf biofast-data-v1.tar.gz 
# 
#real	0m11,929s
#user	0m11,379s
#sys	0m2,875s

#[ Info: extract data...
#┌ Info:    extracted 2 files.
#│ ex-anno.bed
#└ ex-rna.bed
# 11.862949 seconds (752 allocations: 2.047 MiB)

using Tar, GZip

function extract_data(pars)
  my_name="extract_data"
  
  (;verb,datadir,to_extract,) = pars
  tpath=pars.comm["tpath"]

  verb>0 && (println();@info "--> start of $(my_name)")
  verb>1 && (@info to_extract)
  to_extract = filter(x -> !isfile("$(datadir)/$(x)"), to_extract)  # don't overwrite existing files
  verb>1 && (@info to_extract)


  if !isempty(to_extract)
    tmpdir = gzopen(tpath, "r") do io
      Tar.extract(h -> any(endswith.(h.path, to_extract)), io)
    end

    extr=Set{String}()
    for (rd,d,f) in walkdir(tmpdir)
      t_extr=Set{String}()
      for ff in intersect(to_extract,f)
        src=joinpath(rd,ff)
        dest=joinpath(datadir,ff)
        mv(src,dest)
        push!(t_extr,ff)
      end
      isempty(t_extr) && continue
      union!(extr,t_extr)
      setdiff(to_extract,t_extr)
      isempty(to_extract) && break
    end
    if verb>0
      out=["   extracted $(length(extr)) files.",extr...]
      (verb>0) && (@info join(out,"\n"))
    end
  else
    (verb>0) && (@info "   already extracted")
  end
  (verb>0) && (@info "<-- end of $(my_name)")
  
end

using Arrow, CSV, DataFrames, CategoricalArrays

function convert_data(pars)
  _spec = if pars.convert==:original
    convert_original
  elseif pars.convert==:DLMReader
    convert_DLMReader
  else
    @error "convert_data -> $(pars.convert) -> unknown value"
  end
  for bed_name in pars.to_extract
    pars.comm["bed_name"]=bed_name
    _spec(pars)
  end
  
end


function convert_original(pars)
  my_name="convert_original"
  (;
    verb,datadir,overwrite,header,delim,types,replacements,ordered,compress,url,
  )=pars
  bed_name=pars.comm["bed_name"]
  
  verb>0 && (println();@info "--> start of $(my_name)")
  arr_name="$(split(bed_name,".")[1]).arrow"
  push!(pars.comm["arr_names"],arr_name)
  
  bed_name = joinpath(datadir, bed_name)
  arr_name = joinpath(datadir, arr_name)
  if overwrite || !isfile(arr_name)
    ai=(overwrite ? "/overwrite" : "")
    verb>0 && (@info """   convert$(ai) """)
    df = unique!(CSV.read(bed_name, DataFrame; header=header, delim=delim, types=types))
    replace!(df.chromo, replacements...)
    df.chromo =
      categorical(df.chromo; ordered=ordered, levels = sort(unique(df.chromo)))
    Arrow.write(arr_name, df; compress=compress, metadata=["url" => url])
  else
    verb>0 && (@info "   $(arr_name) --> previous instance")
  end
  verb>0 && (@info "<-- end of $(my_name)")
  
  arr_name
end

#using DLMReader

##  even precompiling InMemoryDatasets 2-3 minutes on my machine
##  so at least for smaller projects it is a no-go.
##  some additional setting?

#function convert_DLMReader(pars)
#  my_name="convert_DLMReader"
#  (;
#    verb,overwrite,url,
#    datadir,
#    header,types,
#    delim,linebreak,
#    ordered,compress,
#    replacements, # not implemented -> reasons above
#  )=pars
#  bed_name=pars.comm["bed_name"]
  
#  verb>0 && (println();@info "--> start of $(my_name)")
#  arr_name="$(split(bed_name,".")[1]).arrow"
#  bed_name = joinpath(datadir, bed_name)
#  arr_name = joinpath(datadir, arr_name)
#  if overwrite || !isfile(arr_name)
#    ai=(overwrite ? "(overwrite)" : "")
#    verb>0 && (@info """   converting $(ai) """)
#    Arrow.write(
#      arr_name,
#      DLMReader.filereader(
#        bed_name;
#        delimiter=delim,
#        types=types,
#        header=header,
#        linebreak=linebreak,
#      );
#      compress=compress, 
#      metadata=["url" => url],
#    )
#  else
#    verb>0 && (@info "   already converted")
#  end
#  verb>0 && (@info "<-- end of $(my_name)")
  
#  arr_name
#end

function make_tables(pars)
  my_name="make_tables"
  (;
    verb,
    datadir,
    overwrite,
  )=pars
  
  verb>0 && (println();@info "--> start of $(my_name)")

  ret=Dict{String,Any}()
  for arr_name in pars.comm["arr_names"]
    if overwrite || !haskey(pars.comm,"tbl_$(arr_name)")
      pars.comm["tbl_$(arr_name)"]=Arrow.Table(joinpath(datadir, arr_name))
      verb>0 && (@info "   tbl_$(arr_name) --> processed")
    else
      verb>0 && (@info "   tbl_$(arr_name) --> previous instance")
    end
  end
  verb>0 && (@info "<-- end of $(my_name)")
end

using Arrow, Tables

function make_dicts(pars)
  my_name="make_dict"
  (;verb,datadir,overwrite) = pars
  
  verb>0 && (println();@info "--> start of $(my_name)")
  for arr_name in pars.comm["arr_names"]
    if overwrite || !haskey(pars.comm,"dict_$(arr_name)")
      row_tbl=rowtable(pars.comm["tbl_$(arr_name)"])
      r1 = first(row_tbl)
      itype = promote_type(typeof(r1.start), typeof(r1.stop))
      vtype = Vector{UnitRange{itype}}
      ret = Dict{Symbol,vtype}()
      for (; chromo, start, stop) in row_tbl
        push!(get!(ret, Symbol(chromo), vtype()), (start+one(itype):stop))
      end
      pars.comm["dict_$(arr_name)"]=ret
      verb>0 && (@info "   dict_$(arr_name) --> processed")
    else
      verb>0 && (@info "   dict_$(arr_name) --> previous instance")
    end
  end
  
  verb>0 && (@info "<-- end of $(my_name)")
end

using RangeTrees
function make_trees(pars)
  my_name="make_trees"
  (;verb,datadir,overwrite) = pars
  
  verb>0 && (println();@info "--> start of $(my_name)")
  for arr_name in pars.comm["arr_names"]
    sdict=pars.comm["dict_$(arr_name)"]
    if overwrite || !haskey(pars.comm,"tdict_$(arr_name)")
      pars.comm["tdict_$(arr_name)"]=Dict(k => RangeNode(sort(v)) for (k,v) in sdict)
      verb>0 && (@info "   tdict_$(arr_name) --> processed")
    else
      verb>0 && (@info "   tdict_$(arr_name) --> previous instance")
    end
  end
  
  verb>0 && (@info "<-- end of $(my_name)")
end

