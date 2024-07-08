module MakieThemeing

using Makie

export COLORSCHEME, COLORS, MARKERS, LINESTYLES, DEFAULT_THEME
export figuretitle!, axesgrid, testcolorscheme
export label_axes!, space_out_legend!, textbox!
export lighten, invert_luminance
export Makie

include("themes.jl")
include("convenience.jl")
include("drwatson.jl")

end # module MakieTheme
