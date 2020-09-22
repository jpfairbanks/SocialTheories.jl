using Test
meantest(f::Function, μ::Real, n::Int, ϵ::Real) = begin
    μ̂ = sum(map(f, 1:n))/n
    @test μ - ϵ < μ̂
    @test μ̂ < μ + ϵ
end

