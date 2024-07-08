cd(@__DIR__)
using Documenter, MakieThemeing
pages = ["MakieThemeing" => "index.md"]
makedocs(pages, modules = [MakieThemeing])
