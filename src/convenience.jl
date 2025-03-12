########################################################################################
# Convenience functions
########################################################################################
MakieText = Union{Symbol, <: AbstractString}

"""
    figuretitle!(fig, title; kwargs...)

Add a title to a `Figure`, that looks the same as the title of an `Axis`
by using the same default font. `kwargs` are propagated to `Label`.
"""
function figuretitle!(fig, title;
        valign = :bottom, padding = (0, 0, 0, 0),
        font = "TeX Gyre Heros Bold", # same font as Axis titles
        kwargs...,
    )
    Label(fig[0, :], title;
        tellheight = true, tellwidth = false, fontsize = _LABELSIZE, valign, padding, font, kwargs...
    )
    return
end

"""
    axesgrid(m, n; kwargs...) -> fig, axs

Create a grid of `m` rows and `n` columns of axes in a new figure
and return the figure and the `Matrix` of axis.

## Keyword arguments

- `sharex/sharey = false`: make every row share the y axis and/or every column
  share the x axis. In this case, tick labels are hidden from the shared axes.
- `titles::Vector{String}`: if given, they are used as titles for the axes of the top row.
  Can also be a single `String`, in which case it is used for all axes.
- `xlabels::Vector{String}`: if given, they are used as x labels of the axes
  in the bottom row. Can also be a single `String`, in which case it is used for all axes.
- `ylabels::Vector{String}`: if given, they are used as y labels of the axes in the
  leftmost column. Can also be a single `String`, in which case it is used for all axes.
- `title::String`: if given, it is used as super-title for the entire figure
  using the `figuretitle!` function.
- `xlims/ylims`: if given, they set the limits of x/y for **all** axes.
- `kwargs...`: all further keywords are propagated to `Figure`.
"""
function axesgrid(args...; kwargs...)
    fig = Makie.Figure(; kwargs...)
    axs = axesgrid!(fig, args...; kwargs...)
    return fig, axs
end

"""
    axesgrid!(fig_loc, args...; kw...) -> axs

Do exactly the same with `axesgrid(args...; kw...)`, but generate axes in
a provided figure, or figure location, or grid layout from Makie.jl.
E.g., `fig = Figure(); fig_loc = fig[1,1]`.
"""
function axesgrid!(fig, m, n;
        sharex = false, sharey = false, titles = nothing,
        xlabels = nothing, ylabels = nothing, title = nothing,
        xlims = nothing, ylims = nothing, kwargs...
    )
    axs = Matrix{Axis}(undef, m, n)
    for i in 1:m
        for j in 1:n
            axs[i,j] = Axis(fig[i,j])
        end
    end
    if sharex
        for j in 1:n
            Makie.linkxaxes!(axs[:,j]...)
            for i in 1:m-1; Makie.hidexdecorations!(axs[i,j]; grid = false); end
        end
    end
    if sharey
        for i in 1:m # iterate through rows
            Makie.linkyaxes!(axs[i,:]...)
            for j in 2:n; Makie.hideydecorations!(axs[i,j]; grid = false); end
        end
    end
    if !isnothing(titles)
        for j in 1:n
            axs[1, j].title = titles isa MakieText ? titles : titles[j]
        end
    end
    if !isnothing(xlabels)
        for j in 1:n
            axs[end, j].xlabel = xlabels isa MakieText ? xlabels : xlabels[j]
        end
    end
    if !isnothing(ylabels)
        for i in 1:m
            axs[i, 1].ylabel = ylabels isa MakieText ? ylabels : ylabels[i]
        end
    end
    if !isnothing(xlims)
        for ax in axs; xlims!(ax, xlims); end
    end
    if !isnothing(ylims)
        for ax in axs; ylims!(ax, ylims); end
    end
    !isnothing(title) && figuretitle!(fig, title)
    return axs
end

"""
    label_axes!(axs::Iterable{Axis};
        valign = :top, halign = :right, pad = 4,
        transformation = x -> string(x),
        labels = range('a'; step = 1, length = length(axs)),
        add_box = false, boxkw = NamedTuple(), kw...
    )

Add labels (like a,b,c,...) to all axes.

Keywords adjust location and padding and printing.
All other keywords are propagated to either `Label` or [`textbox!`](@ref),
depending on whether `add_box` is `true`.
"""
function label_axes!(axs;
        labels = range('a'; step = 1, length = length(axs)),
        transformation = identity,
        pad = 4,  valign = :top, halign = :right,
        add_box = false, kwargs...,
    )

    lbs = @. string(transformation(labels))
    # Create padding from alignment options
    padding = fill(2, 4)
    if halign == :right
        padding[2] = pad
    elseif halign == :left
        padding[1] = pad
    end
    if valign == :top
        padding[4] = pad÷2
    elseif valign == :bottom
        padding[3] = pad÷2
    end
    padding = (padding...,)
    extra = (; font = :bold, halign, valign,)
    for (i, ax) in enumerate(axs)
        @assert ax isa Axis
        if !add_box
            gc = ax.layoutobservables.gridcontent[]
            x = gc.parent[gc.span.rows, gc.span.cols]
            Label(x, lbs[i];
                tellwidth=false, tellheight=false, justification = :center,
                padding, extra..., kwargs...
            )
        else
            padding = (pad, pad, pad÷2, pad÷2)
            textbox!(ax, lbs[i]; textpadding = padding, extra..., kwargs...)
        end
    end
    return
end

"""
    textbox!(ax::Axis, text::AbstractString; kw...)

Add a small textbox to `ax` containing the given `text`.
By default, the textbox is placed at the top right corner with proper alignment,
and it is slightly transparent. See the source code for the keywords you need
to adjust for different placement or styling.
"""
function textbox!(ax, text; kw...)
    gc = ax.layoutobservables.gridcontent[]
    pos = gc.parent[gc.span.rows, gc.span.cols]
    Textbox(pos;
        placeholder = text,
        textcolor_placeholder = :black, valign = :top, halign = :right,
        tellwidth = false, tellheight=false, boxcolor = (:white, 0.75),
        textpadding = (2, 2, 2, 2), kw...
    )
    return
end

"""
    space_out_legend!(legend)

Space out the contents of a given legend, so that the banks are spaced equidistantly
and cover the full width available for the legend. This function is supposed to be
called for horizontal legends that should span the full width of a column
and hence are placed either on top or below an axis.
"""
function space_out_legend!(legend)
    Makie.update_state_before_display!(legend.parent)
    # ensure that the width and height are told correctly
    legend.tellwidth[] = false
    legend.tellheight[] = true
    # update axis limits etc, the legend adjustment must come last
    w_available = legend.layoutobservables.suggestedbbox[].widths[1]
    w_used = legend.layoutobservables.computedbbox[].widths[1]
    difference = w_available - w_used
    legend.colgap[] += difference / (legend.nbanks[] - 1)
    return
end
