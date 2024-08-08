```@docs
MakieForProjects
```

```@index
```

## Themeing

When `using MakieForProjects`, a default theme is applied that changes
most theme aspects, and in particular the cycling of colors, markers, and lines.
It makes fontsizes relatively larger (for the set figure size) which is typically
desirable in both papers and presentations. To see all aspects that are changed
see the source code of the `MakieForProjects.make_theme` function.

The color of the theme can be controlled in two ways. One, is by setting environment
three environment variables before using the module:

```julia
# These are the default values
ENV["COLORSCHEME"] = "JuliaDynamics" # or others, see docs
ENV["BGCOLOR"] = :transparent        # anything for `backgroundcolor` of Makie
ENV["AXISCOLOR"] = :black            # color of all axis elements (labels, spines, ticks)

using MakieForProjects # this has now set the theme already!

# you may further edit the set theme by using
Makie.update_theme!(;
    # size = (figwidth, figheight),
)
```

The second way is to do
```julia
using MakieForProjects
theme = MakieForProjects.make_theme(colorcycle, bgcolor, axiscolor)
Makie.set_theme!(theme)
```

And `make_theme` can also be called without arguments, in which case it
uses the same environmental parameters.

## Themes

Themeing in MakieForProjects.jl aims to maximize clarity and aesthetics.

The color schemes in this repo are all composed of 6 colors. Max 6 because if you need more than 6 colors in your figure, you probably need to distinguish data with aspects other than color if you want clarity.

The color schemes have been created through extensive testing, so that their colors are most distinguishable with each other,
visually aesthetic and thematic, are most distinguishable across all three major classes
of color blindness, and are distinguishable also in greyscale (brightness).

Marker and linestyle cycles are added into themeing so that sequential scatter plots
or line plots have different attributes that distinguish them beyond color.

The following constants are exported. The type `CyclicContainer` is a `Vector`-like that implements modulo indexing, wrapping around the indices after the length of the contained elements has been exhausted.

```@example MAIN
using MakieForProjects

COLORS
```

```@example MAIN
MARKERS
```

```@example MAIN
LINESTYLES
```

## Available color schemes

```@example MAIN
using CairoMakie, MakieForProjects

testcolorscheme("JuliaDynamics")
```

```@example MAIN
testcolorscheme("JuliaDynamicsLight")
```

```@example MAIN
testcolorscheme("Petrol")
```

```@example MAIN
testcolorscheme("CloudySky")
```

```@example MAIN
testcolorscheme("Flames")
```

```@example MAIN
testcolorscheme("GreenMetal")
```

## Color manipulation

```@docs
lighten
invert_luminance
fadecolor
```

## Convenience functions

## Axes grid

```@docs
axesgrid
```

## Labelling functions

```@docs
figuretitle!
label_axes!
space_out_legend!
textbox!
```

## Image file manipulation

Besides the functions below, `MakieForProjects` also overloads `DrWatson._wsave`,
so that `wsave` works for `Figure`. By default it increments `px_per_unit = 2` as well.

```@docs
negate_remove_bg
remove_bg
```