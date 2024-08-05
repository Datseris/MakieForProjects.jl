cd(@__DIR__)
using Documenter, MakieThemeing
pages = ["MakieThemeing" => "index.md"]
makedocs(; pages, modules = [MakieThemeing], warnonly = :missing_docs,
    sitename = "MakieForProjects.jl",
)
deploydocs(repo = "github.com/Datseris/MakieForProjects.jl.git")