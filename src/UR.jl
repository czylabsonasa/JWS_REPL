# UR.jl
# intersect  

function Base.intersect!(
  result::Vector{UnitRange{T}},
  target::AbstractUnitRange{<:Integer},
  refs::Vector{UnitRange{T}},
) where {T}
  empty!(result)
  target = UnitRange{T}(target)  # coerce the type, if necessary
  ft,lt = first(target),last(target)
  for ref in refs
    last(ref) < ft && continue
    lt < first(ref) && break
    isect = intersect(target, ref)
    !isempty(isect) && push!(result, isect)
  end
  result
end

function Base.intersect(
  target::AbstractUnitRange{<:Integer},
  refs::Vector{UnitRange{T}},
) where {T}
  intersect!(similar(refs, 0), target, refs)
end
