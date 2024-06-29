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
    "JuliaDynamicsLight" => [ # for usage with dark background
        "#855DE4",
        "#B7BEF1",
        "#15C1A5",
        "#DCC261",
        "#EC59BB",
        "#737A8C",
    ],
    "Petrol" => [
        "#006269",
        "#BD5DAA",
        "#171B37",
        "#86612A",
        "#691105",
        "#00A9B5",
    ],
    "CloudySky" => [
        "#0099CC",
        "#67757E",
        "#1B1D4B",
        "#D07B17",
        "#6F0D4D",
        "#0D9276",
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
        "#35B15A",
        "#748790",
        "#125D1D",
        "#BBA222",
        "#2B33AD",
        "#2B2931",
    ],
)

# ENV["COLORSCHEME"]  = "JuliaDynamicsLight" # change this to test

mutable struct CyclicContainer{V} <: AbstractVector{V}
    c::Vector{V}
    n::Int
end
CyclicContainer(c) = CyclicContainer(c, 0)

Base.size(c::CyclicContainer) = size(c.c)
Base.length(c::CyclicContainer) = length(c.c)
Base.iterate(c::CyclicContainer, state=1) = Base.iterate(c.c, state)
Base.getindex(c::CyclicContainer, i::Int) = c.c[mod1(i, length(c))]
Base.getindex(c::CyclicContainer, i::AbstractVector) = getindex.(Ref(c.c), i)

function Base.getindex(c::CyclicContainer)
    c.n += 1
    c[c.n]
end

########################################################################################
# Set Makie theme
########################################################################################
# The rest require `Makie` accessible in global scope
MARKERS = CyclicContainer([:circle, :dtriangle, :rect, :star5, :xcross, :diamond])
# Linestyles implement a better dash-dot than the original default (too much whitespace)
# and a second dashed style with longer lines between dashes
LINESTYLES = CyclicContainer([:solid, :dash, :dot, Linestyle([0, 3, 4, 5, 6]), Linestyle([0, 5, 6])])

cycle = Cycle([:color, :marker], covary = true)
_FONTSIZE = 16
_LABELSIZE = 20


function __init__()

    COLORSCHEME = COLORSCHEMES[get(ENV, "COLORSCHEME", "JuliaDynamics")]
    BGCOLOR = get(ENV, "BGCOLOR", :transparent)
    AXISCOLOR = get(ENV, "AXISCOLOR", :black)
    global COLORS = CyclicContainer(COLORSCHEME)

    DEFAULT_THEME = Makie.Theme(
        # Main theme (colors, markers, etc.)
        backgroundcolor = BGCOLOR,
        palette = (
            color = COLORSCHEME,
            marker = MARKERS,
            linestyle = LINESTYLES,
            patchcolor = COLORSCHEME,
        ),
        linewidth = 3.0,
        # Sizes of figure and font
        Figure = (
            size = (1000, 600),
            figure_padding = 20,
        ),
        fontsize = _FONTSIZE,
        Axis = (
            xlabelsize = _LABELSIZE,
            ylabelsize = _LABELSIZE,
            titlesize = _LABELSIZE,
            backgroundcolor = BGCOLOR,
            xgridcolor = (AXISCOLOR, 0.5),
            ygridcolor = (AXISCOLOR, 0.5),
            xtickcolor = AXISCOLOR,
            ytickcolor = AXISCOLOR,
            bottomspinecolor = AXISCOLOR,
            topspinecolor = AXISCOLOR,
            leftspinecolor = AXISCOLOR,
            rightspinecolor = AXISCOLOR,
            xlabelcolor = AXISCOLOR,
            ylabelcolor = AXISCOLOR,
            yticklabelcolor = AXISCOLOR,
            xticklabelcolor = AXISCOLOR,
            titlecolor = AXISCOLOR,
        ),
        Legend = (
            patchsize = (40f0, 20),
        ),
        Colorbar = (
            gridcolor = AXISCOLOR,
            tickcolor = AXISCOLOR,
            bottomspinecolor = AXISCOLOR,
            topspinecolor = AXISCOLOR,
            leftspinecolor = AXISCOLOR,
            rightspinecolor = AXISCOLOR,
            labelcolor = AXISCOLOR,
            ticklabelcolor = AXISCOLOR,
            titlecolor = AXISCOLOR,
        ),
        # This command makes the cycle of color and marker
        # co-vary at the same time in plots that use markers
        ScatterLines = (cycle = cycle, markersize = 5),
        Scatter = (cycle = cycle, markersize = 15),
        Band = (cycle = :color,),
        Lines = (cycle = Cycle([:color, :linestyle], covary = true),),
        Label = (textsize = _LABELSIZE,)
    )

    set_theme!(DEFAULT_THEME)
    return COLORS
end

# Testing style (colorscheme)
using Random

function test_new_theme()
    # See also this website to see how the colorscheme looks for colorblind
    # https://davidmathlogic.com/colorblind
    fig = Figure(size = (900, 600)) # show colors
    ax6 = Axis(fig[2,3])
    ax5 = Axis(fig[2,2])
    ax4 = Axis(fig[2,1])
    ax1 = Axis(fig[1,1]; title = "color")
    ax2 = Axis(fig[1,2]; title = "brightness")
    ax3 = Axis(fig[1,3]; title = "saturation")
    linewidth = 60
    L = length(COLORS)
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