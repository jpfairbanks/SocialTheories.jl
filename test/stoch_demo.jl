using Catlab
using Catlab.Theories
using SocialTheories

X = Ob(FreeCartesianCategory, :Float64)
B = Ob(FreeCartesianCategory, :Bool)
u = Hom(x->x*rand(), X, X)
u₀ = Hom(()->rand(), munit(FreeCartesianCategory.Ob), X)

N = Hom((σ)->σ*randn(), X, X)
N₀ = Hom(()->randn(), munit(FreeCartesianCategory.Ob), X)

mI = munit(FreeCartesianCategory.Ob)
diff = Hom((x,y)-> x-y, X⊗X, X)
prod = Hom((x,y)-> x*y, X⊗X, X)
gt = Hom((x,y)-> x>y, X⊗X, B)
lt = Hom((x,y)-> x<=y, X⊗X, B)
Fand = Hom((x,y)-> x&y ? 1 : 0, B⊗B, X)

function simulate(Fperf, Ft₁, Ft₂, Fobs, Fnobs)
    n = 1000
    exp1o = (Ft₁⊗Fobs) ⋅ σ(X,X) ⋅ Fperf
    exp1n = (Ft₁⊗Fnobs) ⋅ σ(X,X) ⋅ Fperf
    exp2o = (Ft₂⊗Fobs) ⋅ σ(X,X) ⋅ Fperf
    exp2n = (Ft₂⊗Fnobs) ⋅ σ(X,X) ⋅ Fperf
    @show μ̂(exp1o, n)
    @show μ̂(exp1n, n)
    @show μ̂(exp2o, n)
    @show μ̂(exp2n, n)
    δ₁ = (exp1o ⊗ exp1n) ⋅ diff
    δ₂ = (exp2o ⊗ exp2n) ⋅ diff
    @show μ̂(δ₁, n)
    @show μ̂(δ₂, n)

    b₁ = (exp1o ⊗ exp1n) ⋅ gt
    b₂ = (exp2o ⊗ exp2n) ⋅ lt

    hyp = (b₁⊗b₂) ⋅ Fand

    @show μ̂(hyp, n)
end

println("\nIn this model of the theory Anxiety/Arousal hypothesis is FALSE > 1/2 the time")
Fperf = Hom((x,y)->5+x+y+randn()/2, X⊗X, X)
Ft₁ = Hom(()->-1+randn()/2, mI, X)
Ft₂ = Hom(()->3+randn()/2, mI, X)
Fobs = Hom(()->2+randn()/3, mI, X)
Fnobs = Hom(()->-1+randn()/3, mI, X)
@assert simulate(Fperf, Ft₁, Ft₂, Fobs, Fnobs)  < 0.5

println("\nIn this model of the theory Anxiety/Arousal hypothesis is TRUE > 1/2 the time")
Fperf = Hom((x,y)->5+x+y+randn()/2 - 1x*y, X⊗X, X)
@assert simulate(Fperf, Ft₁, Ft₂, Fobs, Fnobs) > 0.5

println("\nWe can dial up the random noise to give a higher false positive rate.")
Fperf = Hom((x,y)->5+x+y+2randn() - 1x*y, X⊗X, X)
Ft₁ = Hom(()->-1+2randn(), mI, X)
Ft₂ = Hom(()->3+2randn(), mI, X)
Fobs = Hom(()->2+1randn(), mI, X)
Fnobs = Hom(()->-1+1randn(), mI, X)
@show simulate(Fperf, Ft₁, Ft₂, Fobs, Fnobs) > 0.5

println("\nWe can dial up the random noise to hide the effect completely.")
Fperf = Hom((x,y)->5+x+y+5randn() - 1x*y, X⊗X, X)
Ft₁ = Hom(()->-1+2randn(), mI, X)
Ft₂ = Hom(()->3+2randn(), mI, X)
Fobs = Hom(()->2+2randn(), mI, X)
Fnobs = Hom(()->-1+1randn(), mI, X)
@show simulate(Fperf, Ft₁, Ft₂, Fobs, Fnobs) > 0.5

function simulate(Fperf, Ft₁, Ft₂, Fobs, Fnobs)
    n = 1000
    exp1o = (Ft₁⊗Fobs) ⋅ σ(X,X) ⋅ Fperf
    exp1n = (Ft₁⊗Fnobs) ⋅ σ(X,X) ⋅ Fperf
    exp2o = (Ft₂⊗Fobs) ⋅ σ(X,X) ⋅ Fperf
    exp2n = (Ft₂⊗Fnobs) ⋅ σ(X,X) ⋅ Fperf
    δ₁ = (exp1o ⊗ exp1n) ⋅ diff
    δ₂ = (exp2o ⊗ exp2n) ⋅ diff

    b₁ = (exp1o ⊗ exp1n) ⋅ gt
    b₂ = (exp2o ⊗ exp2n) ⋅ lt
    hyp = (b₁⊗b₂) ⋅ Fand
end
