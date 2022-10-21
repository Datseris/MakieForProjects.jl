########################################################################################
# Colorscheme
########################################################################################
# You can pick colorschemes by setting the `ENV` variable `COLORSCHEME`
COLORSCHEMES = Dict(
    "JuliaDynamics" => [
        "#7143E0",
        "#0A9A84",
        "#171A2F",
        "#F30F0F",
        "#465F00",
        "#701B80",
    ],
)

COLORSCHEME = COLORSCHEMES[get(ENV, "COLORSCHEME", "JuliaDynamics")]

mutable struct CyclicContainer
    c::Vector
    n::Int
end
CyclicContainer(c) = CyclicContainer(c, 0)

Base.length(c::CyclicContainer) = length(c.c)
Base.iterate(c::CyclicContainer, state=1) = Base.iterate(c.c, state)
Base.getindex(c::CyclicContainer, i) = c.c[mod1(i, length(c))]
function Base.getindex(c::CyclicContainer)
    c.n += 1
    c[c.n]
end

COLORS = CyclicContainer(COLORSCHEME)

########################################################################################
# Set Makie theme
########################################################################################
# The rest require `Makie` accessible in global scope
MARKERS = [:circle, :dtriangle, :rect, :pentagon, :xcross, :diamond]
cycle = Cycle([:color, :marker], covary = true)
colorcycle = Cycle([:color, :marker], covary = true)
_FONTSIZE = 18
_LABELSIZE = 24


default_theme = Makie.Theme(
    Figure = (
        resolution = (1000, 600),
    ),
    figure_padding = 4,
    linewidth = 3.0,
    # Font and size stuff:
    fontsize = _FONTSIZE,
    Axis = (
        xlabelsize = _LABELSIZE,
        ylabelsize = _LABELSIZE,
    ),
    palette = (
        color = COLORSCHEME,
        marker = MARKERS,
        patchcolor = COLORSCHEME,
    ),
    # This command makes the cycle of color and marker
    # co-vary at the same time in plots that use markers
    # cycle,
    ScatterLines = (cycle=cycle, markersize = 5),
    Scatter = (cycle=cycle,),
    # Lines = (cycle=:color,), # default
    # Band = (cycle=:color,),  # default
    Label = (textsize = _FONTSIZE + 4,)
)

set_theme!(default_theme)


# Testing style (colorscheme)
if false
    using Random
    fig = Figure(resolution = (1500, 1000)) # show colors
    display(fig)
    ax6 = Axis(fig[2,3])
    ax5 = Axis(fig[2,2])
    ax4 = Axis(fig[2,1])
    ax1 = Axis(fig[1,1]; title = "color")
    ax2 = Axis(fig[1,2]; title = "brightness")
    ax3 = Axis(fig[1,3]; title = "saturation")
    linewidth = 60
    L = length(COLORSCHEME)
    function graycolor(s)
        x = string(s)
        if length(x) == 3
            num = x[3]
        else
            num = x[3:4]
        end
        return "gray"*num
    end
    L = length(COLORS)
    barpos = Random.shuffle(1:4L)
    for (i, c) in enumerate(COLORS)
        chsv = convert(Makie.Colors.HSV, to_color(c))
        lines!(ax1, [0, 1], [0, 0] .+ i; color = c, linewidth)
        lines!(ax2, [0, 1], [0, 0] .+ i; color = graycolor(chsv.v), linewidth)
        lines!(ax3, [0, 1], [0, 0] .+ i; color = graycolor(chsv.s), linewidth)
        local x = 0:0.05:5π
        lines!(ax4, x, rand(1:3) .* cos.(x .+ i/2) .+ rand(length(x))/5; color=c, linewidth = 4)
        barplot!(ax5, barpos[collect(1:4) .+ (i-1)*4], 0.5rand(4) .+ 0.5; width = 1, gap=0.1,color=c)
        scatterlines!(ax6, rand(3), rand(3); linewidth = 4, markersize = 30)
    end
end


########################################################################################
# Convenience functions
########################################################################################
Text = Union{Symbol, <: AbstractString}

"""
    figuretitle!(fig, title; kwargs...)
Add a title to a `Figure`, that looks the same as the title of an `Axis`.
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
    subplotgrid(m, n; sharex = false, sharey = false, kwargs...) -> fig, axs
Create a grid of `m` rows and `n` columns axes in a new figure and return the figure and the
matrix of axis. Optionally make every row share the y axis, and/or every column
to share the x axis. In this case, tick labels are hidden from the shared axes.

See also `subplotgrid!`.
"""
function subplotgrid(m, n;
        sharex = false, sharey = false, titles = nothing,
        xlabels = nothing, ylabels = nothing, title = nothing, kwargs...
    )
    fig = Makie.Figure(;kwargs...)
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
            Makie.linkyaxes!(axs[i,:])
            for j in 2:n; Makie.hideydecorations!(axs[i,j]; grid = false); end
        end
    end
    if !isnothing(titles)
        for j in 1:n
            axs[1, j].title = titles[j]
        end
    end
    if !isnothing(xlabels)
        for j in 1:n
            axs[end, j].xlabel = xlabels isa Text ? xlabels : xlabels[j]
        end
    end
    if !isnothing(ylabels)
        for i in 1:m
            axs[i, 1].ylabel = ylabels isa Text ? ylabels : ylabels[i]
        end
    end
    !isnothing(title) && figuretitle!(fig, title)
    return fig, axs
end

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
Add labels (a), (b), etc. to all axes.
"""
function label_axes!(axs;
        labels = 1:length(axs), transformation = identity,
        valign = :top, halign = :right,
        pad = 5
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
        x = ax.layoutobservables.gridcontent.parent[
            ax.layoutobservables.gridcontent.span.rows,
            ax.layoutobservables.gridcontent.span.cols
        ]
        Label(x, lbs[i];
            tellwidth=false, tellheight=false,
            valign, halign, padding,
        )
    end
    return
end