
include("ex_init.jl")

@time begin
  printstyled("\noverlaps - full\n"; color=:light_yellow)
  df=overlaps(rna, rt_anno)
  printstyled("\n presenting the result for chrX\n", color=:light_yellow)
  df[:chrX] |> display
end
