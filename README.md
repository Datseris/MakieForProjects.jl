# plottheme
Themeing and convenience tools for plotting with Makie.jl used by George Datseris.

To use this, make a Julia file with contents:
```julia
using Makie # or GLMakie, CairoMakie, etc.
import Downloads

ENV["COLORCHEME"] = "JuliaDynamics" # or others, see repo.

try
    Downloads.download(
        "https://raw.githubusercontent.com/Datseris/plottheme/main/plottheme.jl",
        joinpath(@__DIR__, "plottheme.jl")
    )
end

include("plottheme.jl")
```