### reproduce in the `REPL` the 2a,2b sections of the [julia-workshop](https://crsl4.github.io/julia-workshop/)
  - note that the *current* folder will be used for file operations!

```julia
import Pkg
Pkg.activate(; temp=true)
Pkg.add(; url="https://github.com/czylabsonasa/JWS_REPL")
cd(mktempdir()) # this way the dir will be deleted closing your julia session
get_examples()
Pkg.activate("examples") # BenchmarkTools is a dep
Pkg.instantiate()
include("examples/ex_bench.jl")
```
