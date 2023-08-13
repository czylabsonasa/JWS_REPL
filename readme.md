### reproduce in the `REPL` the 2a,2b sections of the [julia-workshop](https://crsl4.github.io/julia-workshop/)
  - all credit goes to the original authors [crsl4](https://github.com/crsl4) and [dmbates](https://github.com/dmbates)!
  - start julia with `-t auto`
  - note that the *current* folder will be used for file operations!

```julia
cd(mktempdir())
import Pkg
Pkg.activate(".")
Pkg.add(; url="https://github.com/czylabsonasa/JWS_REPL")
Pkg.add("BenchmarkTools")
Pkg.resolve()
Pkg.instantiate()
using JWS_REPL
get_examples()
include("examples/ex_full.jl")

#ph

```
  - an example output from my desktop machine:

```julia
julia-1.10> include("examples/ex_bench.jl")
Julia Version 1.10.0-alpha1
Commit f8ad15f7b16 (2023-07-06 10:36 UTC)
Platform Info:
  OS: Linux (x86_64-linux-gnu)
  CPU: 4 × Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-15.0.7 (ORCJIT, skylake)
  Threads: 5 on 4 virtual cores
Environment:
  JULIA_EDITOR = geany


BenchmarkTools.Trial: 8 samples with 1 evaluation.
 Range (min … max):  633.181 ms … 730.457 ms  ┊ GC (min … max): 2.18% … 5.09%
 Time  (median):     679.877 ms               ┊ GC (median):    2.67%
 Time  (mean ± σ):   681.180 ms ±  28.474 ms  ┊ GC (mean ± σ):  2.65% ± 1.39%

  █                   ██     █  █        ██                   █  
  █▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁██▁▁▁▁▁█▁▁█▁▁▁▁▁▁▁▁██▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁█ ▁
  633 ms           Histogram: frequency by time          730 ms <

 Memory estimate: 278.25 MiB, allocs estimate: 1724973.
```

  - and another output from a notebook:
```julia
julia-1.10> include("examples/ex_bench.jl")
Julia Version 1.10.0-beta1
Commit 6616549950e (2023-07-25 17:43 UTC)
Platform Info:
  OS: Linux (x86_64-linux-gnu)
  CPU: 4 × Intel(R) Core(TM) i7-6500U CPU @ 2.50GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-15.0.7 (ORCJIT, skylake)
  Threads: 5 on 4 virtual cores
Environment:
  JULIA_EDITOR = geany


BenchmarkTools.Trial: 5 samples with 1 evaluation.
 Range (min … max):  1.133 s …   1.196 s  ┊ GC (min … max): 0.00% … 4.49%
 Time  (median):     1.151 s              ┊ GC (median):    3.69%
 Time  (mean ± σ):   1.164 s ± 28.033 ms  ┊ GC (mean ± σ):  2.45% ± 2.23%
```

