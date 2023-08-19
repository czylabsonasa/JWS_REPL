
include("ex_init.jl")

using BenchmarkTools

versioninfo()
print("\n\n")


@benchmark overlaps(targets, refs) setup = (targets = rna; refs = rt_anno)

