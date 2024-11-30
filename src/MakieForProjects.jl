module MakieForProjects

# Use the README as the module docs
@doc let
    path = joinpath(dirname(@__DIR__), "README.md")
    include_dependency(path)
    read(path, String)
end MakieForProjects

using Makie

export COLORSCHEME, COLORS, MARKERS, LINESTYLES, DEFAULT_THEME
export figuretitle!, axesgrid, testcolorscheme
export label_axes!, space_out_legend!, textbox!
export lighten, invert_luminance, fadecolor
export Makie, testcolortheem
export negate_remove_bg, remove_bg

include("themes.jl")
include("colormanip.jl")
include("convenience.jl")
include("drwatson.jl")

function __init__()
    theme = make_theme()
    global COLORS = CyclicContainer(COLORSCHEMES[get(ENV, "COLORSCHEME", "JuliaDynamics")])
    set_theme!(theme)
    return
end

end # module MakieTheme
