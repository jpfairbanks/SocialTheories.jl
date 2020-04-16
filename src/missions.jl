using Catlab
using Catlab.Doctrines
using Catlab.Syntax

using Catlab.Graphics
using Catlab.Graphics.ComposeWiringDiagrams

using Catlab.WiringDiagrams
using Catlab.Programs

@present Studies(FreeCartesianCategory) begin
    # measurement types
    Measure::Ob
    Count::Ob
    Time::Ob
    Response::Ob

    subtype₁::Hom(Count, Measure)
    subtype₂::Hom(Time, Measure)
    subtype₃::Hom(Response,Measure)

    Workload::Ob
    Team::Ob
    Tool::Ob
    Knowledge::Ob
    Strategy::Ob
    Traj::Ob
    Question::Ob

    # given the trajectory they followed, how many (red,green) victims did they save?
    nsaved::Hom(Traj, Count⊗Count)
    time::Hom(Traj, Time)

    # given the instructions from the experimenter, make a plan for playing the game
    plan::Hom(Knowledge⊗Tool, Strategy)
    # after the first mission you have memory of the strategy you used for the previous mission
    replan::Hom(Knowledge⊗Tool⊗Strategy, Strategy)

    # execute the playing of the game given your strategy
    play::Hom(Strategy, Traj)
    # ask₀ is for pre-hoc questions and ask₁ is for post-hoc questions
    ask₀::Hom(Question⊗Strategy, Response⊗Strategy)
    ask₁::Hom(Question⊗Traj, Response⊗Strategy)

    # ask the same question to all the participants
    question::Hom(munit(), Question)
end;
#
# @theory Studies(FreeAbelianBicategoryRelations) begin
#     # measurement types
#     Measure::Ob
#     Count::Ob
#     Time::Ob
#     Response::Ob
#
#     subtype₁::(Count → Measure)
#     subtype₂::(Time → Measure)
#     subtype₃::(Response → Measure)
#
#     Workload::Ob
#     Team::Ob
#     Tool::Ob
#     Knowledge::Ob
#     Strategy::Ob
#     Traj::Ob
#     Question::Ob
#
#     # given the trajectory they followed, how many (red,green) victims did they save?
#     nsaved::(Traj → Count⊗Count)
#     time::(Traj → Time)
#
#     # given the instructions from the experimenter, make a plan for playing the game
#     plan::(Knowledge⊗Tool → Strategy)
#     # after the first mission you have memory of the strategy you used for the previous mission
#     replan::(Knowledge⊗Tool⊗Strategy → Strategy)
#
#     # execute the playing of the game given your strategy
#     play::(Strategy → Traj)
#     # ask₀ is for pre-hoc questions and ask₁ is for post-hoc questions
#     ask₀::(Question⊗Strategy → Response⊗Strategy)
#     ask₁::(Question⊗Traj → Response⊗Strategy)
#
#     # ask the same question to all the participants
#     question::(munit()→ Question)
# end
#

# @theory Studies(AbelianBicategoryRelations) begin
#     constant(X::Ob)::(munit()→X)
#     cast(X::Ob,Y::Ob)::(X → Y)
#     ask(q::Question, Y::Ob, Z::Ob)::(Y→Z)
#     ask!(q::Question, Y::Ob, Z::Ob)::(Y→Y⊗Z)
#     # given the trajectory they followed, how many (red,green) victims did they save?
#     nsaved::(Traj → Count⊗Count)
#     time::(Traj → Time)
#
#     # given the instructions from the experimenter, make a plan for playing the game
#     plan::(Knowledge⊗Tool → Strategy)
#     # after the first mission you have memory of the strategy you used for the previous mission
#     replan::(Knowledge⊗Tool⊗Strategy → Strategy)
#
#     # execute the playing of the game given your strategy
#     play::(Strategy → Traj)
#     # ask₀ is for pre-hoc questions and ask₁ is for post-hoc questions
#
#     # ask the same question to all the participants
#     question::(munit()→ Question)
# end
