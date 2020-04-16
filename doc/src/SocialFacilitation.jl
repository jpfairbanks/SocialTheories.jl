using SocialTheories
using Catlab

using Catlab.Doctrines
using Catlab.Syntax

using Convex, SCS, TikzPictures
using Compose: draw, PGF
using Catlab.Graphics
using Catlab.Graphics.ComposeWiringDiagrams

using Catlab.WiringDiagrams


using Catlab.Programs
import Catlab.WiringDiagrams: to_hom_expr

moduleof(p::Presentation) = typeof(first(generators(p))).name.module
to_hom_expr(p::Presentation, f::WiringDiagram) = to_hom_expr(moduleof(p), f)

using AutoHashEquals


# mcopy(A::Ports{SymmetricMonoidalCategory.Hom}, n::Int) = junctioned_mcopy(A, n)

# Doctrines
###########

"""
    Doctrine of *Social Models*, ...
"""
# @theory SymmetricMonoidalCategory(Ob,Hom) => SocialModels(Ob,Hom) begin
#
# end
#
# @syntax FreeSocialModels(ObExpr,HomExpr) SocialModels begin
#   otimes(A::Ob, B::Ob) = associate_unit(new(A,B), mzero)
#   otimes(f::Hom, g::Hom) = associate(new(f,g))
#   compose(f::Hom, g::Hom) = new(f,g; strict=true) # No normalization!
# end

"""    SocialFacilitation: our first psychological theory

We include:

    1. types for numbers and booleans,
    2. arithmetic and logical operators,
    3. constant values like true, false, easy, hard, and observed,
    4. a causal mechanism perform(audience::Bool, task::Bool)::Number

Our social facilitation hypothesis can be expressed in this theory.
"""

# @present SocialFacilitation(FreeCartesianCategory) begin
#     Number::Ob
#     Bool::Ob
#     Task::Ob
#
#     plus::Hom(Number⊗Number, Number)
#     diff::Hom(Number⊗Number, Number)
#     times::Hom(Number⊗Number, Number)
#     div::Hom(Number⊗Number, Number)
#
#     and::Hom(Bool⊗Bool, Bool)
#     neg::Hom(Bool, Bool)
#     eq::Hom(Number⊗Number, Bool)
#     neq::Hom(Number⊗Number, Bool)
#
#     ⊤::Hom(munit(), Bool)
#     ⊥::Hom(munit(), Bool)
#
#     t1::Hom(munit(), Task)
#     t2::Hom(munit(), Task)
#
#     observed::Hom(munit(), Bool)
#
#     perform::Hom(Task⊗Bool, Number)
# end


""" Our first hypothesis says that for any given task, a participant
will perform better when observed, than when not observed.
"""

sfmodel = @program SocialFacilitation (task::Task) begin
    a = observed()
    t = task
    s₁ = perform(t, a)
    s₂ = perform(t, neg(a))
    return neq(s₁, s₂)
end

viz(sfmodel)

open("model1.tex", "w") do fp
    SocialTheories.tikzrender(fp, SocialFacilitation, sfmodel)
end

""" Our second hypothesis says that the effect of social facilitation
depends on the difficulty of the task. For easy tasks observers increase performance
but for not easy tasks they decrease performance.
"""

ttmodel = @program SocialFacilitation () begin
    a = observed()
    ua = neg(a)
    t = t1()
    s₁ = perform(t, a)
    s₂ = perform(t, ua)
    b₁ = neq(s₁, s₂)

    t = t2()
    s₁ = perform(t, a)
    s₂ = perform(t, ua)
    b₂ = neq(s₁, s₂)
    return and(b₁, b₂)
end

viz(ttmodel)

open("model2.tex", "w") do fp
    tikzrender(fp, SocialFacilitation, ttmodel)
end

# Refinement Functor ArousalAnxietyFacilitation => SocialFacilitation
# (arousal⊗anxiety)⋅performance ↦ perform,
# < ↦ !=
# > ↦ !=
# identity everywhere else
# any model of SocialFacilitation is a model of ArousalAnxietyFacilitation

begin
    ArousalAnxietyFacilitation = deepcopy(SocialFacilitation)
    # gens = [Ob(FreeCartesianCategory.Ob, x) for x in [:arousal, :anxiety, :performance]]
    b, num = generators(SocialFacilitation, [:Bool, :Number])
    gens = [
        Hom(:arousal, num, num),
        Hom(:anxiety, num, num),
        Hom(:performance, num⊗num, num),
        Hom(:gt, num⊗num, b),
        Hom(:lt, num⊗num, b)
    ]
    map(g->add_generator!(ArousalAnxietyFacilitation, g), gens)

    arousal, anxiety, performance = gens
    rhs = (arousal⊗anxiety)⋅performance
    perform = generator(SocialFacilitation, :perform)
    add_equation!(ArousalAnxietyFacilitation, perform, rhs)
end

# @present ArousalAnxietyFacilitation(FreeCartesianCategory) begin
#     Number::Ob
#     Bool::Ob
#     Task::Ob
#
#     plus::Hom(Number⊗Number, Number)
#     diff::Hom(Number⊗Number, Number)
#     times::Hom(Number⊗Number, Number)
#     div::Hom(Number⊗Number, Number)
#
#     and::Hom(Bool⊗Bool, Bool)
#     neg::Hom(Bool, Bool)
#     eq::Hom(Number⊗Number, Bool)
#     neq::Hom(Number⊗Number, Bool)
#     gt::Hom(Number⊗Number, Bool)
#     lt::Hom(Number⊗Number, Bool)
#
#     ⊤::Hom(munit(), Bool)
#     ⊥::Hom(munit(), Bool)
#
#     t1::Hom(munit(), Task)
#     t2::Hom(munit(), Task)
#
#     observed::Hom(munit(), Bool)
#
#     arousal::Hom(Bool, Number)
#     anxiety::Hom(Task, Number)
#     performance::Hom(Number⊗Number, Number)
# end


""" Our second hypothesis says that the effect of social facilitation
depends on the difficulty of the task. For easy tasks observers increase performance
but for not easy tasks they decrease performance.
"""
aamodel = @program ArousalAnxietyFacilitation () begin
    a = observed()
    ua = neg(a)
    t = t1()
    s₁ = performance(anxiety(t), arousal(a))
    s₂ = performance(anxiety(t), arousal(ua))
    b₁ = gt(s₁, s₂)

    t = t2()
    s₁ = performance(anxiety(t), arousal(a))
    s₂ = performance(anxiety(t), arousal(ua))
    b₂ = lt(s₁, s₂)
    return and(b₁, b₂)
end

viz(aamodel)
open("model3.tex", "w") do fp
    tikzrender(fp, ArousalAnxietyFacilitation, aamodel)
end

@present HighLevel(FreeCartesianCategory) begin
    Number::Ob
    Bool::Ob
    Task::Ob

    plus::Hom(Number⊗Number, Number)
    diff::Hom(Number⊗Number, Number)
    times::Hom(Number⊗Number, Number)
    div::Hom(Number⊗Number, Number)

    and::Hom(Bool⊗Bool, Bool)
    neg::Hom(Bool, Bool)
    eq::Hom(Number⊗Number, Bool)
    neq::Hom(Number⊗Number, Bool)
    gt::Hom(Number⊗Number, Bool)
    lt::Hom(Number⊗Number, Bool)

    ⊤::Hom(munit(), Bool)
    ⊥::Hom(munit(), Bool)

    t1::Hom(munit(), Task)
    t2::Hom(munit(), Task)

    observed::Hom(munit(), Bool)

    arousal::Hom(Bool, Number)
    anxiety::Hom(Task, Number)
    performance::Hom(Number⊗Number, Number)

    manipulate::Hom(munit(), Task⊗Task⊗Bool⊗Bool)
    experiment::Hom(Task⊗Task⊗Bool⊗Bool, Number⊗Number⊗Number⊗Number)
    comparison::Hom(Number⊗Number⊗Number⊗Number, Bool)
end

    # experiment::Hom(s::Task, t::Task, obs::Bool, nobs::Bool)

hlmodel = @program HighLevel () begin
    conditions = manipulate()
    data = experiment(conditions)
    result = comparison(data)
    return result
end

viz(hlmodel)
