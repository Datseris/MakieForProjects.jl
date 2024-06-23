module MakieThemeing

using Makie

export COLORSCHEME, COLORS, MARKERS, LINESTYLES, DEFAULT_THEME
export figuretitle!, axesgrid, subplotgrid
export label_axes!, space_out_legend!, textbox!
export lighten, invert_luminance

include("themes.jl")
include("convenience.jl")
include("drwatson.jl")

function __init__()
    set_theme!(DEFAULT_THEME)
end

end # module MakieTheme
