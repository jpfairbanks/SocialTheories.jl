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

@present SocialFacilitation(FreeBiproductCategory) begin
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

    ⊤::Hom(munit(), Bool)
    ⊥::Hom(munit(), Bool)

    t1::Hom(munit(), Task)
    t2::Hom(munit(), Task)

    observed::Hom(munit(), Bool)

    perform::Hom(Task⊗Bool, Number)
end

# Refinement Functor ArousalAnxietyFacilitation => SocialFacilitation
# (arousal⊗anxiety)⋅performance ↦ perform,
# < ↦ !=
# > ↦ !=
# identity everywhere else
# any model of SocialFacilitation is a model of ArousalAnxietyFacilitation

begin
    ArousalAnxietyFacilitation = deepcopy(SocialFacilitation)
    # gens = [Ob(FreeBiproductCategory.Ob, x) for x in [:arousal, :anxiety, :performance]]
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
