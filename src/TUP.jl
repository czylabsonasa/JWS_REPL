# TUP.jl
# intersect/convert

function convert(::Type{Tuple{S,S}},x::UnitRange{<:Integer}) where {S<:Integer}
  (S(first(x)),S(last(x)))
end

function intersect(A::Tuple{T,T}, B::Tuple{T,T}) where {T<:Integer}
  C=(T(max(first(A),first(B))),T(min(last(A),last(B))))
  (first(C)>last(C)) && (return ()) # it is empty
  C
end


function intersect!(
  result::Vector{Tuple{T,T}},
  target::Tuple{<:Integer,<:Integer},
  refs::Vector{Tuple{T,T}},
) where {T}
  empty!(result)
  target = (T(target[1]),T(target[2]))  # coerce the type, if necessary
  ft,lt = target
  for ref in refs
    last(ref) < ft && continue
    lt < first(ref) && break
#    isect = intersect(target, ref)
    push!(result,(max(ft,first(ref)),min(lt,last(ref))))

#    !isempty(isect) && push!(result, isect)
  end
  result
end

function intersect(
  target::Tuple{<:Integer,<:Integer},
  refs::Vector{Tuple{T,T}}
) where {T}
  intersect!(similar(refs, 0), target, refs)
end
