# plottheme
Themeing and convenience tools for plotting with Makie.jl used by George Datseris.

To use this, make a Julia file with contents:
```julia
using Makie # or GLMakie, CairoMakie, etc.
import Downloads

try
    Downloads.download(
        "https://github.com/Datseris/plottheme/blob/main/plottheme.jl/",
        joinpath(@__DIR__, "plottheme.jl")
    )
end

include("plottheme.jl")
```