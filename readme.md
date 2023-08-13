### reproduce in the `REPL` the 2a,2b sections of the [julia-workshop](https://crsl4.github.io/julia-workshop/)

```julia
import Pkg
tdir="jl_$(hash(1))"
Pkg.activate(tdir)
Pkg.add(;url="https://github.com/czylabsonasa/JWS_REPL")
cd(tdir) # sadly, there are some relative reference


include("examples/ex_bench.jl")
.
..
...
..
.

# run(`rm -rf $(tdir)`)

```

