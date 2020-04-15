using Catlab

using Catlab
using Catlab.Doctrines
using Catlab.Syntax
using Catlab.Graphics
using Catlab.Graphics.ComposeWiringDiagrams
using Catlab.WiringDiagrams
using Catlab.Programs

# Doctrines
###########
@present KnowledgeModels(FreeBiproductCategory) begin
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


@present KnowledgeModelsBC(FreeCartesianCategory) begin
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
