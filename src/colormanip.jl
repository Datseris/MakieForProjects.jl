########################################################################################
# Color manipulation
########################################################################################
"""
    invert_luminance(color)

Return a color with same hue and saturation but luminance inverted.
"""
function invert_luminance(color)
    c = to_color(color)
    hsl = Makie.HSLA(c)
    l = 1 - hsl.l
    neg = Makie.RGBA(Makie.HSLA(hsl.h, hsl.s, l, hsl.alpha))
    return neg
end

"""
    lighten(c, f = 1.2)

Lighten given color `c` by multiplying its luminance with `f`.
If `f` is less than 1, the color is darkened.
"""
function lighten(c, f = 1.2)
    c = to_color(c)
    hsl = Makie.HSLA(c)
    neg = Makie.RGBAf(Makie.HSLA(hsl.h, hsl.s, clamp(hsl.l*f, 0.0, 1.0), hsl.alpha))
    neg = Makie.RGBf(Makie.HSL(hsl.h, hsl.s, clamp(hsl.l*f, 0.0, 1.0)))
    return neg
end

"""
    fadecolor(c::ColorLike, N::Int, f = 0.5)

Create a vector of `N` colors based on `c` but that "fade away" towards
full transparency. The alpha channel (transparency) scales as `t^fade` with `t`
ranging from 0 to 1 (1 being the end of the returned color vector).
Use `fade = 1` for linear fading or `fade = 0` for no fading. Current default
makes fading progress faster at start and slower towards the end.

Note: due to how makie handles transparency and different colors in a single
line segment, if using `fadecolor` with `lines!` plots, it is best
to also use the keywords:
```
linecap = :butt, joinstyle = :round
```
"""
function fadecolor(c, N::Int, f = 0.5)
    fade = Float32(f)
    x = to_color(c)
    x = [RGBAf(x.r, x.g, x.b, (i/N)^(fade)) for i in 1:N]
    return x
end
