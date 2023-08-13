
include("ex_init.jl")

@time begin
  printstyled("\noverlaps - full\n"; color=:light_yellow)
  df=overlaps(rna, anno)
  df[:chrX] |> display
end
