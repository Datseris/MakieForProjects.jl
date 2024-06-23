# MakieThemeing.jl

Theming and convenience tools for plotting with Makie.jl used by George Datseris.
You are more than welcomed to use this to benefit from the color themes,
or the convenience functions within. Feel free to contribute PRs adding your own themes or more convenience functions.

I develop color themes using the website <https://davidmathlogic.com/colorblind/>
and the internal function `test_new_theme()`.

## Usage

Simply add the repo url via `Pkg.add`.
Altering themeing properties is done via environment variables before using the module, eg

```julia
ENV["COLORSCHEME"] = "JuliaDynamics" # or others, see `plottheme.jl`
ENV["BGCOLOR"] = :transparent       # anything for `backgroundcolor` of Makie
ENV["AXISCOLOR"] = :black           # color of all axis elements (labels, spines, ticks)

using MakieThemeing
```