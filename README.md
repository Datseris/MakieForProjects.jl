# plottheme

Theming and convenience tools for plotting with Makie.jl used by George Datseris.

To use this, make a Julia file with contents:
```julia
if !any(name -> isdefined(Main, name), [:Makie, :GLMakie, :CairoMakie])
    using CairoMakie
end
import Downloads

# decide theme:
ENV["COLORCHEME"] = "JuliaDynamics" # or others, see `plottheme.jl`
ENV["BGCOLOR"] = :transparent       # anything for `backgroundcolor` of Makie
ENV["AXISCOLOR"] = :white           # color of all axis elements (labels, spines, ticks)

try
    Downloads.download(
        "https://raw.githubusercontent.com/Datseris/plottheme/main/plottheme.jl",
        joinpath(@__DIR__, "_plottheme.jl")
    )
    cp(joinpath(@__DIR__, "_plottheme.jl"), joinpath(@__DIR__, "plottheme.jl"))
    rm(joinpath(@__DIR__, "_plottheme.jl"))
catch
end

include("plottheme.jl")
```

If the project uses DrWatson's module-based activation, via `@quickactivate :MyProjectName`, then these commands need to be put in the module's `__init__()` function instead:

```julia
function __init__()
    set_theme!(default_theme)
    # whatever else you want:
    update_theme!(;
        resolution = (42, 123),
        Lines = (cycle = Cycle([:color, :linestyle], covary = true),),
    )
end
```
