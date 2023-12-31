"""
    module JWS_REPL
  - play with https://crsl4.github.io/julia-workshop without qmd
"""


module JWS_REPL
  include("utils.jl")
  export 
    get_examples,
    download_data, 
    extract_data, 
    convert_data, 
    make_tables, 
    make_dicts,
    make_trees

  import Base: convert, intersect, intersect!

  include("rt_related.jl")
  export coveragecount, overlaps

end # of module
