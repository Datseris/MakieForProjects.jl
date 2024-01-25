# plottheme

Theming and convenience tools for plotting with Makie.jl used by George Datseris.

To use this, make a Julia file with contents:
```julia
using Makie # or GLMakie, CairoMakie, etc.
import Downloads

ENV["COLORCHEME"] = "JuliaDynamics" # or others, see `plottheme.jl`

try
    Downloads.download(
        "https://raw.githubusercontent.com/Datseris/plottheme/main/plottheme.jl",
        joinpath(@__DIR__, "plottheme.jl")
    )
catch
end

include("plottheme.jl")
```

If the project uses DrWatson's module-based activation, via `@quickactivate :MyProjectName`, then these two commands need to be put in the module's `__init__()` function instead:

```julia
function __init__()
    set_theme!(default_theme)
    update_theme!(;
        resolution = (figwidth, figheight),
        Lines = (cycle = Cycle([:color, :linestyle], covary = true),),
    )
end
```
