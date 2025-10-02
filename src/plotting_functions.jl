"""
    streamlines!(ax, x, y; kw...)

A `lines!` plot that decorates the lines with triangles with same orientation as the local
tangent to the line. This is a single-line version of a `streamplot`.
All keywords are propagated to `lines!` with the exception of `markersize` that scales the
triangle size.

The additional keyword `idxs` denotes to which indices of the x-y curve to add directional
triangles. It defaults to `[length(x)÷2, length(x)]`.
"""
function streamlines!(ax, x, y; idxs = [length(x)÷2, length(x)], space = :data, color = Cycled(1), markersize = 15, kw...)
    x = collect(x)
    y = collect(y)
    lines!(ax, x, y; color, space, kw...)
    for index in idxs
        dx = x[index] .- x[index-1]
        dy = y[index] .- y[index-1]
        φ = atan(dy, dx)
        scatter!(ax, x[index], y[index]; color, space, markersize, rotation = φ, marker = :rtriangle, )
    end
    return
end

"""
    fadelines!(ax, x, y; fade = 0.5, kw...)

Same as [`fadecolor`](@ref) but also call `lines!` with the resulting color
and the same instructions as `fadecolor`.
"""
function fadelines!(ax, args...; fade = 0.5, color = :black, kw...)
    c = fadecolor(color, length(args[1]), fade)
    lines!(ax, args...; linecap = :butt, joinstyle = :round, kw..., color = c)
    return
end
