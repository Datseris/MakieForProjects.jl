export COLORSCHEME, COLORS, MARKERS, LINESTYLES
export figuretitle!, axesgrid, subplotgrid
export label_axes!, space_out_legend!

########################################################################################
# Colorscheme
########################################################################################
# You can pick colorschemes by setting the `ENV` variable `COLORSCHEME`
COLORSCHEMES = Dict(
    "JuliaDynamics" => [
        "#7143E0",
        "#191E44",
        "#0A9A84",
        "#AF9327",
        "#791457",
        "#6C768C",
    ],
    "Petrol" => [
        "#006269",
        "#BD5DAA",
        "#171B37",
        "#86612A",
        "#691105",
        "#00A9B5",
    ],
    "Flames" => [
        "#84150F",
        "#D65A35",
        "#E2B830",
        "#36454F",
        "#B2BEB5",
        "#9C278C",
    ],
    "GreenMetal" => [
        "#478C5C",
        "#184B29",
        "#2B1E1E", # darkest
        "#8A9EA0",
        "#224269",
        "#A2CD88", # lightest
    ],

)

COLORSCHEME = COLORSCHEMES[get(ENV, "COLORSCHEME", "JuliaDynamics")]
# ENV["TEST_NEW_THEME"] = true
TEST_NEW_THEME = get(ENV, "TEST_NEW_THEME", "false") == "true"

mutable struct CyclicContainer
    c::Vector
    n::Int
end
CyclicContainer(c) = CyclicContainer(c, 0)

Base.length(c::CyclicContainer) = length(c.c)
Base.iterate(c::CyclicContainer, state=1) = Base.iterate(c.c, state)
Base.getindex(c::CyclicContainer, i) = c.c[mod1(i, length(c))]
Base.getindex(c::CyclicContainer, i::AbstractRange) = c.c[i]

function Base.getindex(c::CyclicContainer)
    c.n += 1
    c[c.n]
end

COLORS = CyclicContainer(COLORSCHEME)

########################################################################################
# Set Makie theme
########################################################################################
# The rest require `Makie` accessible in global scope
MARKERS = [:circle, :dtriangle, :rect, :star5, :xcross, :diamond]
# Linestyles implement a better dash-dot than the original default (too much whitespace)
# and a second dashed style with longer lines between dashes
LINESTYLES = [:solid, :dash, :dot, [0, 3, 4, 5, 6], [0, 5, 6]]
cycle = Cycle([:color, :marker], covary = true)
_FONTSIZE = 18
_LABELSIZE = 24


default_theme = Makie.Theme(
    # Main theme (colors, markers, etc.)
    palette = (
        color = COLORSCHEME,
        marker = MARKERS,
        linestyle = LINESTYLES,
        patchcolor = COLORSCHEME,
    ),
    linewidth = 3.0,
    # Sizes of figure and font
    Figure = (
        resolution = (1000, 600),
        figure_padding = 20,
    ),
    fontsize = _FONTSIZE,
    Axis = (
        xlabelsize = _LABELSIZE,
        ylabelsize = _LABELSIZE,
        titlesize = _LABELSIZE,
    ),
    Legend = (
        patchsize = (40f0, 20),
    ),
    # This command makes the cycle of color and marker
    # co-vary at the same time in plots that use markers
    ScatterLines = (cycle = cycle, markersize = 5),
    Scatter = (cycle = cycle, markersize = 15),
    Band = (cycle = :color,),
    Label = (textsize = _LABELSIZE,)
)

set_theme!(default_theme)


# Testing style (colorscheme)
if TEST_NEW_THEME
    using Random
    fig = Figure(resolution = (1200, 800)) # show colors
    ax6 = Axis(fig[2,3])
    ax5 = Axis(fig[2,2])
    ax4 = Axis(fig[2,1])
    ax1 = Axis(fig[1,1]; title = "color")
    ax2 = Axis(fig[1,2]; title = "brightness")
    ax3 = Axis(fig[1,3]; title = "saturation")
    linewidth = 60
    L = length(COLORSCHEME)
    function graycolor(s)
        x = round(Int, 100s)
        return "gray"*string(x)
    end
    barpos = Random.shuffle(1:4L)
    for (i, c) in enumerate(COLORS)
        chsv = convert(Makie.Colors.HSV, to_color(c))
        lines!(ax1, [0, 1], [0, 0] .+ i; color = c, linewidth)
        lines!(ax2, [0, 1], [0, 0] .+ i; color = graycolor(chsv.v), linewidth)
        lines!(ax3, [0, 1], [0, 0] .+ i; color = graycolor(chsv.s), linewidth)
        local x = 0:0.05:5π
        lines!(ax4, x, rand(1:3) .* cos.(x .+ i/2) .+ rand(length(x))/5; color=c, linewidth = 4)
        barplot!(ax5, barpos[collect(1:4) .+ (i-1)*4], 0.5rand(4) .+ 0.5; width = 1, gap=0,color=c)
        scatterlines!(ax6, rand(3), rand(3); linewidth = 4, markersize = 30, color=c)
    end
    display(fig)
end


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
        tellheight = true, tellwidth = false, valign, padding, font, kwargs...
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
- `kwargs...`: all further keywords are propagated to `Figure`.
"""
function axesgrid(m, n;
        sharex = false, sharey = false, titles = nothing,
        xlabels = nothing, ylabels = nothing, title = nothing, kwargs...
    )
    fig = Makie.Figure(; kwargs...)
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
    !isnothing(title) && figuretitle!(fig, title)
    return fig, axs
end
const subplotgrid = axesgrid

if isdefined(Main, :DrWatson)
    # Extension of DrWatson's save functionality for default CairoMakie saving
    function DrWatson._wsave(filename, fig::Makie.Figure, args...; kwargs...)
        if filename[end-3] != '.'; filename *= ".png"; end
        if isdefined(Main, :CairoMakie)
            CairoMakie.activate!()
            CairoMakie.save(filename, fig, args...; px_per_unit = 4, kwargs...)
            if isdefined(Main, :GLMakie)
                GLMakie.activate!()
            end
        else
            Makie.save(filename, fig, args...; kwargs...)
        end
    end

    """
        negate_remove_bg(file)
    Create an inverted version of the image at `file` with background removed.
    """
    function negate_remove_bg(file)
        # Expects white background image
        img = DrWatson.FileIO.load(file)
        x = map(img) do px
            neg = Makie.RGB(one(eltype(img)) - px)
            bg = abs2(neg) < 0.01 ? 0 : 1
            Makie.RGBA(neg, bg)
        end
        name, ext = splitext(file)
        FileIO.save(name*"_inv"*ext, x)
    end
end


"""
    label_axes!(axs::Array{Axis};
        valign = :top, halign = :right, pad = 5, kwargs...
    )

Add labels (like a,b,c,...) to all axes.
Keywords customly adjust location, and `kwargs` are propagated to `Label`.
"""
function label_axes!(axs;
        labels = range('a'; step = 1, length = length(axs)),
        transformation = x -> "("*string(x)*")",
        valign = :top, halign = :right,
        pad = 5, kwargs...,
    )

    lbs = @. string(transformation(labels))
    # Create padding from alignment options
    padding = [0,0,0,0]
    if halign == :right
        padding[2] = pad
    elseif halign == :left
        padding[1] = pad
    end
    if valign == :top
        padding[3] = pad
    elseif valign == :bottom
        padding[4] = pad
    end

    for (i, ax) in enumerate(axs)
        @assert ax isa Axis
        gc = ax.layoutobservables.gridcontent[]
        x = gc.parent[gc.span.rows, gc.span.cols]
        # Currently `Label` has no way of having a box around it
        lab = Label(x, lbs[i];
            tellwidth=false, tellheight=false,
            valign, halign, padding, font = :bold, justification = :center,
            kwargs...
        )
        # but we can access the internals and get the box of the label,
        # and then make an actual box around it
        bx = Box(first(axs).parent; bbox = lab.layoutobservables.computedbbox, color = "gray")
        Makie.translate!(bx.blockscene, 0, 0, -1)
    end
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