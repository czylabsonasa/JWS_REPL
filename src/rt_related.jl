 using RangeTrees, AbstractTrees

# intersect related


# for this project we do not need these methods of intersect
#function Base.intersect!(
#  result::Vector{UnitRange{T}},
#  target::AbstractUnitRange{<:Integer},
#  refs::Vector{UnitRange{T}},
#) where {T}
#  empty!(result)
#  target = UnitRange{T}(target)  # coerce the type, if necessary
#  ft,lt = first(target),last(target)
#  for ref in refs
#    last(ref) < ft && continue
#    lt < first(ref) && break
#    isect = intersect(target, ref)
#    !isempty(isect) && push!(result, isect)
#  end
#  result
#end

#function Base.intersect(
#  target::AbstractUnitRange{<:Integer},
#  refs::Vector{UnitRange{T}},
#) where {T}
#  intersect!(similar(refs, 0), target, refs)
#end
# coverage.jl

function coveragecount(
  target::AbstractUnitRange,
  isects::Vector{UnitRange{T}},
) where {T}
  leftpost, rightpost = T(first(target)), T(last(target))
  coverage = 0
  for isect in isects
    (leftpost > rightpost || first(isect) > rightpost) && break
    
    coverage += length(intersect(isect, leftpost:rightpost))
    leftpost = max(leftpost, last(isect) + one(T))
  end
  return coverage
end

#function AbstractTrees.treesize(rn::RangeNode)
#  length(rn.inds)
#end


function overlaps(targets::Vector{UnitRange{T}}, refs::RangeNode{T,R}) where {T,R}
  nover = similar(targets, Int)
  covcount = similar(targets, T)
  result = empty!(similar(targets, ceil(Int, sqrt(treesize(refs)))))
#  result = empty!(similar(targets, 1024))

  @inbounds for (i, tar) in enumerate(targets)
    nover[i] = length(intersect!(result, tar, refs)) # this method is defined in the package
    covcount[i] = coveragecount(tar, result)
  end
  DataFrame(targets = targets, nover = nover, covcount = covcount)
end


function overlaps(
  tardict::Dict{Symbol,Vector{UnitRange{T}}},
  refdict::Dict{Symbol,RangeNode{T,R}},
) where {T,R}
  matchedkeys = intersect(keys(tardict), keys(refdict))
  result = Dict(k => DataFrame() for k in matchedkeys) # pre-assign key/value pairs
  @sync for k in matchedkeys
    Threads.@spawn result[k] = overlaps(tardict[k], refdict[k])
  end
  return result
end
