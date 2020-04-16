using SocialTheories
using Test
using Catlab
using Catlab.Doctrines
using Catlab.Syntax
using Catlab.WiringDiagrams
using Catlab.Programs

isdiagram(x) = begin
    @test typeof(x) <: WiringDiagram
end

@testset "Wiring Diagrams" begin
    @testset "SocialFacilitation" begin
        include("socialfacilitation.jl")
    end

    @testset "Satisficing" begin
        include("satisficing.jl")
    end
end
