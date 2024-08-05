cd(@__DIR__)
using Documenter, MakieForProjects
pages = ["MakieForProjects" => "index.md"]
makedocs(; pages, modules = [MakieForProjects], warnonly = :missing_docs,
    sitename = "MakieForProjects.jl",
)
deploydocs(repo = "github.com/Datseris/MakieForProjects.jl.git")