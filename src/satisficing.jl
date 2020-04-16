using SocialTheories
using Catlab
using Catlab.Doctrines
using Catlab.Syntax



@present Satisficing(FreeCartesianCategory) begin
    # variable types
    Number::Ob
    Bool::Ob
    Mission::Ob
    Goal::Ob

    # arithmetic operators
    plus::Hom(Number⊗Number, Number)
    diff::Hom(Number⊗Number, Number)
    times::Hom(Number⊗Number, Number)
    div::Hom(Number⊗Number, Number)

    # logical operators
    and::Hom(Bool⊗Bool, Bool)
    neg::Hom(Bool, Bool)
    eq::Hom(Number⊗Number, Bool)
    neq::Hom(Number⊗Number, Bool)
    gt::Hom(Number⊗Number, Bool)
    lt::Hom(Number⊗Number, Bool)

    # constants
    ⊤::Hom(munit(), Bool)
    ⊥::Hom(munit(), Bool)

    goal1::Hom(munit(), Goal)
    goal2::Hom(munit(), Goal)

    mission1::Hom(munit(), Mission)
    mission2::Hom(munit(), Mission)

    highST::Hom(munit(), Number)
    lowST::Hom(munit(), Number)
    popST::Hom(munit(), Number)

    univariate::Hom(munit(), Number)

    # causal mechanisms
    goalsetting::Hom(Goal, Number)
    timepressure::Hom(Number, Number)
    aspirations::Hom(Goal, Number)
    sattend::Hom(Number, Number)
    satisficing::Hom(Number⊗Number⊗Number, Number)

    #measures
    difftriage::Hom(Number, Number)
    nasatlx::Hom(Number, Number)
    stinv::Hom(Number, Number)
    goalscomm::Hom(Number, Number)

end

Sat = deepcopy(Satisficing)

f,g,h, sat, dt = generators(Sat, [:aspirations, :timepressure, :popST, :satisficing, :difftriage])
add_definition!(Sat, :sat, (f⊗g⊗h)⋅sat⋅dt)
