using Catlab

using Catlab
using Catlab.Doctrines
using Catlab.Syntax

using Catlab.Graphics
using Catlab.Graphics.ComposeWiringDiagrams

using Catlab.WiringDiagrams


wd(x) = to_wiring_diagram(x)

#display(x) = to_composejl(add_junctions!(wd(x)), direction=:horizontal, labels=true)
draw(x::WiringDiagram) = to_graphviz(add_junctions(x), orientation=LeftToRight, labels=true)
draw(x) = draw(to_wiring_diagram(x))
using Catlab.Programs
#compile_expr(f, name=:acc_train, args=[:query], arg_types=[:Query])

import Catlab.WiringDiagrams: to_hom_expr

moduleof(p::Presentation) = typeof(first(generators(p))).name.module
to_hom_expr(p::Presentation, f::WiringDiagram) = to_hom_expr(moduleof(p), f)

@present Studies(FreeAbelianBicategoryRelations) begin
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

Measure, Count, Time, Repsponse = generators(Studies, [:Measure, :Count, :Time, :Response])
Workload, Team, Tool, Knowledge, Strategy, Traj, Question = generators(Studies, [:Workload, :Team, :Tool, :Knowledge, :Strategy, :Traj, :Question])
nsaved, time, plan, replan, play, ask₀, ask₁, question = generators(Studies, [:nsaved, :time, :plan, :replan, :play, :ask₀, :ask₁, :question])

draw(plan)


export LinearFunctions, FreeLinearFunctions, LinearRelations,
  FreeLinearRelations, LinearMapDom, LinearMap,
  Ob, Hom, dom, codom, compose, ⋅, ∘, id, oplus, ⊗, mzero, braid,
  dagger, dunit, docunit, mcopy, Δ, delete, ◊, mmerge, ∇, create, □,
  pplus, zero, coplus, cozero, plus, +, meet, top, join, bottom,
  scalar, antipode, antipode, adjoint, evaluate

import Base: +
using AutoHashEquals
# using LinearMaps
# import LinearMaps: adjoint
# const LMs = LinearMaps

using ...Catlab, ...Doctrines
import ...Doctrines:
  Ob, Hom, dom, codom, compose, ⋅, ∘, id, oplus, ⊕, mzero, braid,
  dagger, dunit, dcounit, mcopy, Δ, delete, ◊, mmerge, ∇, create, □,
  plus, zero, coplus, cozero, meet, top, join, bottom
using ...Programs
import ...Programs: evaluate_hom

# Doctrines
###########

""" Doctrine of *DOLL Models*, ...

"""
@theory SymmetricMonoidalCategory(Ob,Hom) => KnightModel(Ob,Hom) begin

end

@syntax FreeKnight(ObExpr,HomExpr) KnightModel begin
  otimes(A::Ob, B::Ob) = associate_unit(new(A,B), mzero)
  otimes(f::Hom, g::Hom) = associate(new(f,g))
  compose(f::Hom, g::Hom) = new(f,g; strict=true) # No normalization!
end
@present KnowledgeModels(FreeSymmetricMonoidalCategory) begin
    Workload::Ob
    Option::Ob
    KBP::Ob
    Task::Ob
    Component::Ob
    Coordinate::Ob
    Observer::Ob
    BehaviorChange::Ob
    Actions::Ob
    Player::Ob
    KBEfficiency::Ob
    KBEffectiveness::Ob
    Stress::Ob
    Score::Ob

    task::Hom(Component⊗Coordinate, Task)
    difficulty::Hom(Task, Workload)
    efficiency::Hom(Actions⊗Task⊗Score, KBEfficiency)
    effectiveness::Hom(Actions⊗Task⊗Score, KBEffectiveness)
    perform::Hom(Workload⊗Task, Actions⊗KBP)
    complexity::Hom(Task, Component⊗Coordinate)
    estimate::Hom(Observer⊗Task⊗Actions, Workload)
    infer::Hom(Actions⊗Observer, BehaviorChange)
    fneirs::Hom(Workload, Stress)
    agentperf::Hom(Stress⊗Workload, Score)
    identify::Hom(Actions⊗Observer, Task)
    agentrecognition::Hom(Task⊗Task, Score)
end


@present KnowledgeModels(FreeSymmetricMonoidalCategory) begin
    Workload::Ob
    Option::Ob
    KBP::Ob
    Task::Ob
    Component::Ob
    Coordinate::Ob
    Observer::Ob
    BehaviorChange::Ob
    Actions::Ob
    Player::Ob
    KBEfficiency::Ob
    KBEffectiveness::Ob
    Stress::Ob
    Score::Ob

    task::Hom(Component⊗Coordinate, Task)
    difficulty::Hom(Task, Workload)
    efficiency::Hom(Actions⊗Task⊗Score, KBEfficiency)
    effectiveness::Hom(Actions⊗Task⊗Score, KBEffectiveness)
    perform::Hom(Workload⊗Task, Actions⊗KBP)
    complexity::Hom(Task, Component⊗Coordinate)
    estimate::Hom(Observer⊗Task⊗Actions, Workload)
    estimate′::Hom(Observer⊗Task⊗BehaviorChange, Workload)
    infer::Hom(Actions⊗Observer, BehaviorChange)
    fneirs::Hom(Workload, Stress)
    agentperf::Hom(Stress⊗Workload, Score)
    identify::Hom(Actions⊗Observer, Task)
    agentrecognition::Hom(Task⊗Task, Score)
end


model = @program KnowledgeModels (wl::Workload, t::Task, obs::Observer) begin
    actions, perf = perform(wl, t)
    comc, cooc    = complexity(t)
    wl_hat        = estimate(obs, t, actions)
    return perf,comc, cooc, wl_hat
end
model = @program KnowledgeModels (wl::Workload, t::Task, obs::Observer) begin
    actions, perf = perform(wl, t)
    comc, cooc    = complexity(t)
    bc = infer(actions, obs)
    wl_hat        = estimate′(obs, t, bc)
    return perf,comc, cooc, wl_hat
end

# TA 3 Experiment Goal
model = @program KnowledgeModels (c1::Component, c2::Coordinate, obs::Observer) begin
    t = task(c1, c2)
    wl = difficulty(t)
    actions, perf = perform(wl, t)
    wl_hat        = estimate(obs, t, actions)
    t̂ = identify(actions, obs)
    ap = agentperf(fneirs(wl), wl_hat)
    return ap, check(t,t̂)
end


# James Hypoth 1: component, coordinate cause high stress
# James Hypoth 2: if corr(Stress, wl_hat) > 0.8 then agent is good, else agent sucks
# James Hypoth 3: Humans are better observers than AI Agents on average
# James Hypoth 4: Humans are better observers than AI Agents on high component complexity tasks
# James Hypoth 5: AI Agents are better observers than Humans on low component complexity tasks

# UCF Hypoth 1: More workload => less KBEfficiency gathering
# UCF Hypoth 2: More workload => less KBEffectiveness synth
model = @program KnowledgeModels (c1::Component, c2::Coordinate) begin
    t = task(c1, c2)
    wl = difficulty(t)
    actions, perf = perform(wl, t)
    return efficiency(actions, t, perf), effectiveness(actions, t, perf)
end
# UCF Hypoth 3: Agents can detect high v low workload,
# UCF Hypoth 4/5: Agents can detect info gathering vs synth vs other
model = @program KnowledgeModels (c1::Component, c2::Coordinate, obs::Observer) begin
    t = task(c1, c2)
    wl = difficulty(t)
    actions, perf = perform(wl, t)
    wl_hat        = estimate(obs, t, actions)
    t̂ = identify(actions, obs)
    ap = agentperf(fneirs(wl), wl_hat)
    return ap, agentrecognition(t,t̂)
end
draw(model)


model = @program KnowledgeModels (c1::Component, c2::Coordinate, obs::Observer) begin
    t = task(c1, c2)
    wl = difficulty(t)
    actions, perf = perform(wl, t)
    wl_hat        = estimate(obs, t, actions)
    t̂ = identify(actions, obs)
    ap = agentperf(fneirs(wl), wl_hat)
    return efficiency(actions, t, perf), effectiveness(actions, t, perf), ap, agentrecognition(t,t̂)
end
draw(model)

# TODO planned complexity vs actual complexity

#
# functor(
#     Workload => Categorical(:High, :Low)
#     Task => Categorical(:Gather, :Synthesize)
#     Observer => Observer(AI=true, mode=:Ignorant)
#     KBP => Float
#     Component => [0,1]
#     Coordinate => [0,1]
#
#     difficulty => P(workload | task)
#     perform => P(actions, perf | workload, task) = ...
#     complexity => P(comc, coord | task) = ...
#     estimate => ...
#
# )
# y = P(Y|X)
