# why: 
# to be able to execute several times without iterating the same task that is done before

using JWS_REPL

if !isdefined(Main,:comm)
  comm = Dict{String,Any}( 
    "arr_names"=>[],
  )
end
comm["arr_names"]=[]

if !haskey(comm, "init_done") || (comm["init_done"] == false) 
  ex_params=(
    datadir = "data",
    to_extract = ("ex-anno.bed", "ex-rna.bed"), # function / regex ?
    #url = "https://github.com/lh3/biofast/releases/download/biofast-data-v1/biofast-data-v1.tar.gz",
    url = "http://localhost:8000/biofast-data-v1.tar.gz", # for testing LiveServer.jl is used
    header = [:chromo, :start, :stop],
    types = [String, Int32, Int32],
    compress = :lz4,
    replacements = ["chr$(i)" => "chr0$(i)" for i in 1:9],
    ordered = true,
    delim = '\t',
    linebreak = '\n',
    overwrite = false,
    verb = 1,
    convert = :original,
    #convert = :DLMReader,
    # comm -> shared between the routines
    comm = comm,
  )


  download_data(ex_params)
  extract_data(ex_params)
  convert_data(ex_params)
  make_tables(ex_params)
  make_dicts(ex_params)

  ex_params.comm["arr_names"] = ["ex-anno.arrow"] # make tree only from anno
  make_trees(ex_params)
  println()


  rna = comm["dict_ex-rna.arrow"]
  anno = comm["tdict_ex-anno.arrow"]

  comm["init_done"] = true
end

