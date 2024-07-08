# MakieThemeing.jl

Theming and convenience tools for plotting with Makie.jl developed to be particularly helpful in academic work, in particular for making figures for papers.
You are more than welcomed to use this to benefit from the color themes,
or the convenience functions within. Feel free to contribute PRs adding your own themes or more convenience functions.

The color themes in this repo are all composed of 6 colors.
They have been created through extensive testing, so that their colors are most distinguishable with eaceh other,
visually aesthetic and thematic, are most distinguishable across all three major classes
of color blindness, and are distingushable also in greyscale (brightness).
In our experience, all color schemes here are more distinguishable from Makie's
default color scheme, and more aesthetically pleasing as well.

## Usage

Simply add the repo via `Pkg.add`.
When `using MakieThemeing`, a default theme is applied that changes
most theme aspects, and in particular the cycling of colors, markers, and lines.

Color themeing can be controlled in two ways. One, is by setting environment
three environment variables before using the module:

```julia
ENV["COLORSCHEME"] = "JuliaDynamics" # or others, see docs
ENV["BGCOLOR"] = :transparent        # anything for `backgroundcolor` of Makie
ENV["AXISCOLOR"] = :black            # color of all axis elements (labels, spines, ticks)

using MakieThemeing

Makie.update_theme!(;
    # size = (figwidth, figheight),
)
```

The second way is to do
```julia
using MakieThemeing
theme = MakieThemeing.make_theme(colorcycle, bgcolor, axiscolor)
Makie.set_theme!(theme)
```

for all other information, see the online docs: