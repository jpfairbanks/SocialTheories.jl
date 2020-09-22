using SocialTheories
import SocialTheories: save_wd
using Catlab

using Catlab.Theories
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

mkpath("socialfacilitation")

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
save_wd(sfmodel, "socialfacilitation/sfmodel.svg")

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
save_wd(ttmodel, "socialfacilitation/ttmodel.svg")

open("model2.tex", "w") do fp
    tikzrender(fp, SocialFacilitation, ttmodel)
end

#=
Refinement Functor ArousalAnxietyFacilitation => SocialFacilitation
 (arousal⊗anxiety)⋅performance ↦ perform,
 < ↦ !=
 > ↦ !=
 identity everywhere else
 any model of SocialFacilitation is a model of ArousalAnxietyFacilitation

    @present ArousalAnxietyFacilitation <: SocialFacilitation begin
        arousal::Hom(Number, Number)
        anxiety::Hom(Number, Number)
        performance::Hom(Number⊗Number, Number)
        gt::Hom(Number⊗Number, Bool)
        lt::Hom(Number⊗Number, Bool)

        perform == (arousal⊗anxiety)⋅performance
    end
=#

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
save_wd(aamodel, "socialfacilitation/aamodel.svg")
# open("model3.tex", "w") do fp
#     tikzrender(fp, ArousalAnxietyFacilitation, aamodel)
# end

@present HighLevel(FreeCartesianCategory) begin
    Number::Ob
    Bool::Ob
    Task::Ob
    Condition::Ob

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

    manipulate::Hom(munit(), Condition⊗Condition⊗Condition⊗Condition)
    experiment::Hom(Condition, Number)
    comparison::Hom(Number⊗Number⊗Number⊗Number, Bool)

    task::Hom(Condition, Task)
    observation::Hom(Condition, Bool)
    cond::Hom(Task⊗Bool, Condition)
end

    # experiment::Hom(s::Task, t::Task, obs::Bool, nobs::Bool)

hlmodel = @program HighLevel () begin
    conditions = manipulate()
    data = [experiment(c) for c in conditions]
    result = comparison(data...) # := comparison(data[1], data[2], data[3], data[4])
    return result
end

viz(hlmodel)
save_wd(hlmodel, "socialfacilitation/hlmodel.svg")


exp = @program HighLevel (c::Condition) begin
    t, o = task(c), observation(c)
    return performance(arousal(o), anxiety(t))
end

viz(exp)

manip = @program HighLevel () begin
    c11 = cond(t1(), observed())
    c21 = cond(t2(), observed())
    c12 = cond(t1(), neg(observed()))
    c22 = cond(t2(), neg(observed()))
    return c11, c12, c21, c22
end

viz(manip)
save_wd(manip, "socialfacilitation/manip.svg")

cmp = @program HighLevel (a::Number, b::Number, c::Number, d::Number) begin
    return and(gt(a,b), lt(c,d))
end

d0 = substitute(hlmodel, 8, cmp)
d1 = substitute(d0, 4, exp)
d2 = substitute(d1, 3, manip)

viz(d2)
save_wd(d2, "socialfacilitation/d2.svg")

manip′ = @program HighLevel () begin
    c11 = (t1(), observed())
    c21 = (t2(), observed())
    c12 = (t1(), neg(observed()))
    c22 = (t2(), neg(observed()))
    return c11, c12, c21, c22
end

viz(manip′)
save_wd(manip′, "socialfacilitation/manipprime.svg")

exp = @program HighLevel (obs::Bool, t::Task) begin
    return performance(arousal(obs), anxiety(t))
end

viz(exp)
save_wd(exp, "socialfacilitation/exp.svg")

viz(cmp)
save_wd(cmp, "socialfacilitation/cmp.svg")

# compose(manip′, otimes(exp, exp, exp, exp), cmp)
