"""
    streamlines!(ax, x, y; kw...)

A `lines!` plot that decorates the lines with triangles with same orientation as the local
tangent to the line. It combines a `lines!` plot with a `scatter!` plot of oriented triangles.
Keywords are propagated to both `lines!, scatter!` if they are shared, otherwise only to `lines!`.

The additional keyword `idxs` denotes to which indices of the x-y curve to add directional
triangles. It defaults to `[length(x)÷2, length(x)]`.
"""
function streamlines!(ax, x, y; idxs = [length(x)÷2, length(x)], space = :data, color = Cycled(1), markersize = 15, kw...)
    x = collect(x)
    y = collect(y)
    objects = []
    push!(objects, lines!(ax, x, y; color, space, kw...))
    φs = map(idxs) do index
        dx = x[index] .- x[index-1]
        dy = y[index] .- y[index-1]
        atan(dy, dx)
    end
    # TODO: @lift the indices on x/y it also works with observables
    push!(objects, scatter!(ax, x[idxs], y[idxs]; color, space, markersize, rotation = φs, marker = :rtriangle, ))
    return objects
end

function streamlines!(ax, xy;
        idxs = [length(xy)÷2, length(xy)], space = :data, color = Cycled(1),
        markersize = 15, translate = (0, 0, 99), kw...
    )
    objects = []
    push!(objects, lines!(ax, xy; color, space, kw...))
    # TODO: @lift the indices on x/y it also works with observables
    φs = map(idxs) do index
        dxy = xy[index] .- xy[index-1]
        atan(dxy[2], dxy[1])
    end
    push!(objects, scatter!(ax, xy[idxs]; color, space, markersize, rotation = φs, marker = :rtriangle, ))
    translate!.(objects, translate...)
    return objects
end


"""
    fadelines!(ax, x, y; fade = 0.5, kw...)

A `lines!` plot using [`fadecolor`](@ref) for color as well as the accompanying instructions.
"""
function fadelines!(ax, args...; fade = 0.5, color = :black, kw...)
    c = fadecolor(color, length(args[1]), fade)
    lines!(ax, args...; linecap = :butt, joinstyle = :round, kw..., color = c)
    return
end
