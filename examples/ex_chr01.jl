
include("ex_init.jl")

sel = :chr01

@time begin
  printstyled("\noverlaps - only for $(sel)\n"; color=:light_yellow)
  overlaps(rna[sel], rt_anno[sel])|>display
end
