using DrWatson

# Extension of DrWatson's save functionality for default CairoMakie saving
function DrWatson._wsave(fullpath, fig::Makie.Figure, args...; kwargs...)
    path = dirname(fullpath)
    filename = basename(fullpath)
    if '.' ∉ filename # it has no file ending
        filename *= ".png"
    end
    Makie.save(joinpath(path, filename), fig, args...; px_per_unit = 2, kwargs...)
end

# Using FileIO's load to make figures for black slides
"""
    negate_remove_bg(file; threshold = 0.02, bg = :white, overwrite = false)

Create an negated (or color inverted) version of the image at `file` with background removed,
so that it may be used in environments with dark background.
The `threshold` decides when a pixel should be made transparent.
If the image already has a dark background, pass `bg = :black` instead,
which will not negate the image but still remove the background.
"""
function negate_remove_bg(file; threshold = 0.02, bg = :white, overwrite = false)
    img = DrWatson.FileIO.load(file)
    x = map(px -> invert_color(px, bg, threshold), img)
    if overwrite
        newname = file
    else
        name, ext = splitext(file)
        newname = name*"_inv"*ext
    end
    DrWatson.FileIO.save(newname, x)
end

function invert_color(px, bg = :white, threshold = 0.02)
    hsl = Makie.HSLA(to_color(px))
    l = (bg == :white) ? (1 - hsl.l) : hsl.l
    neg = Makie.RGB(Makie.HSL(hsl.h, hsl.s, l))
    α = abs2(neg) < threshold ? 0 : hsl.alpha
    Makie.RGBA(neg, α)
end
function negate_remove_save(filename, fig::Makie.Figure)
    DrWatson.wsave(filename, fig)
    negate_remove_bg(filename; overwrite = true)
end

"""
    remove_bg(file; threshold = 0.02, overwrite = false)

Remove the background for figure in `file` (all pixels with luminosity > 1 - threshold).
Either overwrite original file or make a copy with suffix _bgr.
"""
function remove_bg(file; threshold = 0.02, overwrite = false)
    img = DrWatson.FileIO.load(file)
    x = map(px -> make_transparent_pixel(px, threshold), img)
    if overwrite
        newname = file
    else
        name, ext = splitext(file)
        newname = name*"_bgr"*ext
    end
    DrWatson.FileIO.save(newname, x)
end
function make_transparent_pixel(px, threshold = 0.02)
    α = Makie.RGBA(to_color(px)).alpha
    c = Makie.RGB(to_color(px))
    α = abs2(c) > 1 - threshold ? 0 : α
    return Makie.RGBA(c, α)
end
