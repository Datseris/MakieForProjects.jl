cd(@__DIR__)
using Documenter, MakieThemeing
pages = ["MakieThemeing" => "index.md"]
makedocs(; pages, modules = [MakieThemeing], warnonly = :missing_docs,
    sitename = "MakieThemeing.jl",
)
deploydocs(repo = "github.com/Datseris/MakieThemeing.jl.git")