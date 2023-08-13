
include("ex_init.jl")

@time begin
  printstyled("\noverlaps - full\n"; color=:light_yellow)
  overlaps(rna, anno) |> display
end
