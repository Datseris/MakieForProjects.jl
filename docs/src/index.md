```@docs
MakieThemeing
```

```@index
```

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

## Axes grid

```@docs
axesgrid
```

## Other plotting convenience functions

```
figuretitle!
label_axes!
space_out_legend!
textbox!
```

## Color manipulation

```@docs
lighten
invert_liminance
```

## Color schemes


```@example
using CairoMakie, MakieThemeing

testcolorscheme("JuliaDynamics")
```

```@example
testcolorscheme("JuliaDynamicsLight")
```

```@example
testcolorscheme("Petrol")
```

```@example
testcolorscheme("CloudySky")
```

```@example
testcolorscheme("Flames")
```

```@example
testcolorscheme("GreenMetal")
```

## Other themeing

Marker and linestyle cycles are added into themeing.
The following constants are exported. The type `CyclicContainer` is a `Vector`-like that implements modulo indexing, wrapping around the indices after the length of the contained elements has been exhausted.

```@example
COLORS
```

```@example
MARKERS
```

```@example
LINESTYLES
```

## Image file manipulation

Besides the functions below, `MakieThemeing` also overloads `DrWatson._wsave`,
so that `wsave` works for `Figure`. By default it increments `px_per_unit = 2`.

```@docs
negate_remove_bg
remove_bg
```