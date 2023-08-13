"""
    module JWS_REPL
  - play with https://crsl4.github.io/julia-workshop without qmd
"""


module JWS_REPL
  include("utils.jl")
  export 
    download_data, 
    extract_data, 
    convert_data, 
    make_tables, 
    make_dicts,
    make_trees

  import Base: convert, intersect, intersect!

  include("UR.jl")
#  include("TUP.jl")
#  include("PAIR.jl")
  
  include("coverage.jl")
  export coveragecount, overlaps

end # of module
