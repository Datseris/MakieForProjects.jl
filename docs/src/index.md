```@docs
MakieThemeing
```

```@index
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