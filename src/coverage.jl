# coverage.jl

function coveragecount(
  target::AbstractUnitRange,
  isects::Vector{UnitRange{T}},
) where {T}
  leftpost, rightpost = T(first(target)), T(last(target))
  coverage = 0
  for isect in isects
    coverage += length(intersect(isect, leftpost:rightpost))
    leftpost = max(leftpost, last(isect) + one(T))
  end
  return coverage
end


using RangeTrees

function overlaps(targets::Vector{UnitRange{T}}, refs::RangeNode{T}) where {T}
  nover = similar(targets, Int)
  covcount = similar(targets, T)
  result = empty!(similar(targets, ceil(Int, sqrt(treesize(refs)))))
  @inbounds for (i, tar) in enumerate(targets)
    nover[i] = length(intersect!(result, tar, refs))
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
