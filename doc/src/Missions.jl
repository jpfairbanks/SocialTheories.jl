using SocialTheories
using Catlab
using Catlab.Doctrines
using Catlab.Syntax

using Catlab.Graphics
using Catlab.Graphics.ComposeWiringDiagrams
using Catlab.WiringDiagrams
using Catlab.Programs

display(x) = viz(x)

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

d₁ = @program Studies (k::Knowledge, t::Tool) begin
    j = play(plan(k,t))
    return nsaved(j), time(j)
end
display(d₁)

d₂ = @program Studies (k::Knowledge, t::Tool) begin
    q = question()
    s = plan(k,t)
    r, s = ask₀(q, s)
    j = play(s)
    return r, nsaved(j), time(j)
end

display(d₂)

d₃ = @program Studies (k::Knowledge, t::Tool) begin
    q₁ = question()
    s = plan(k,t)
    r₁, s = ask₀(q₁, s)
    j = play(s)
    q₂ = question()
    r₂,s = ask₁(q₂, j)
    return r₁, r₂, nsaved(j), time(j)
end
display(d₃)

d₃ = @program Studies (k::Knowledge, t::Tool) begin
    q₁ = question()
    s = plan(k,t)
    r₁, s = ask₀(q₁, s)
    j = play(s)
    r₂, s = ask₁(q₁, j)
    return r₁, r₂, s, nsaved(j), time(j)
end
display(d₃)

strat, resp, count, time = generators(Studies, [:Strategy, :Response, :Count, :Time])
d₄ = d₃⋅to_wiring_diagram(braid(resp⊗resp, strat)⊗id(count⊗count⊗time))
display(d₄)


d₅ = @program Studies (k::Knowledge, t::Tool, s::Strategy) begin
    q₁ = question()
    s = replan(k,t, s)
    r₁, s = ask₀(q₁, s)
    j = play(s)
    r₂, s = ask₁(q₁, j)
    return r₁, r₂, nsaved(j), time(j)
end
display(d₅)

know,tool = generators(Studies, [:Knowledge, :Tool])
d₆ = (to_wiring_diagram(id(know⊗tool))⊗d₄)⋅(d₅⊗to_wiring_diagram(id(resp⊗resp⊗count⊗count⊗time)))
display(d₆)

d₇ = (mcopy(know)⊗id(tool⊗tool))⋅(id(know)⊗braid(know,tool)⊗id(tool)) |> to_wiring_diagram
display(d₇)

display(d₇⋅d₆)

d₇ = (id(know⊗know)⊗mcopy(tool))⋅(id(know)⊗braid(know,tool)⊗id(tool)) |> to_wiring_diagram
display(d₇)

display(d₇⋅d₆)

dm = @program Studies (c₁::Count, c₂::Count, t::Time) begin
    [subtype₁(c₁), subtype₁(c₂), subtype₂(t)]
end
display(dm)

to_hom_expr(Studies, dm)

dm₂ = @program Studies (r₁::Response, r₂::Response, m::Measure) begin
    [subtype₃(r₁), subtype₃(r₂), m]
end
dm₃ = (to_wiring_diagram(id(resp⊗resp))⊗dm)⋅dm₂
display(dm₃)

display(to_wiring_diagram(id(strat))⊗dm₃)

display(d₄)

mission₁ = d₄⋅(to_wiring_diagram(id(strat))⊗dm₃)
display(mission₁)

m₂ = @program Studies (k::Knowledge, t::Tool, s::Strategy) begin
    q₁ = question()
    s = replan(k,t, s)
    r₁, s = ask₀(q₁, s)
    j = play(s)
    r₂, s = ask₁(q₁, j)
    return s, r₁, r₂, nsaved(j), time(j)
end
mission₂ = m₂⋅(to_wiring_diagram(id(strat))⊗dm₃)
display(mission₂)

meas = generator(Studies, :Measure)
m₁₊₂ = (to_wiring_diagram(id(know⊗tool))⊗mission₁)⋅(mission₂⊗to_wiring_diagram(id(meas)))⋅to_wiring_diagram(id(strat)⊗mmerge(meas))
display(m₁₊₂)

m₁₊₂₊₃ = (to_wiring_diagram(id(know⊗tool))⊗m₁₊₂)⋅(mission₂⊗to_wiring_diagram(id(meas)))⋅to_wiring_diagram(delete(strat)⊗mmerge(meas))
display(m₁₊₂₊₃)

shared_tool = @program Studies (t::Tool, k₁::Knowledge, k₂::Knowledge, k₃::Knowledge) begin
    return t, k₃, t, k₂, t, k₁
end

display(add_junctions(shared_tool⋅m₁₊₂₊₃))

mh₁ = Hom(:mission₁, tool⊗know, strat⊗meas)
mh₂ = Hom(:mission₂, strat⊗tool⊗know, strat⊗meas)

try
    add_generator!(Studies, mh₁)
    add_generator!(Studies, mh₂)
catch
    println("Mission Homs already added to the presentation")
end

mission² = @program Studies (k₂::Knowledge, k₁::Knowledge, t::Tool) begin
    s, m₁ = mission₁(k₁,t)
    s, m₂ = mission₂(s, k₂, t)
    return s, m₁,m₂
end
display(mission²)

display(ocompose(mission², 1, mission₁))

ocompose(mission², 1, mission₁)

display(ocompose(ocompose(mission², 1, mission₁), 15-2, mission₂))

substitute(mission², box_ids(mission²), [mission₁, mission₂]) == ocompose(ocompose(mission², 1, mission₁), 15-2, mission₂)

mission³ = @program Studies (k₁::Knowledge, k₂::Knowledge, k₃::Knowledge, t::Tool) begin
    s, m₁ = mission₁(k₁,t)
    s, m₂ = mission₂(s, k₂, t)
    s, m₃ = mission₂(s, k₃, t)
    return m₁, m₂, m₃
end
display(mission³)

substitute(mission³, [3,4,5], [mission₁, mission₂, mission₂]) == ocompose(ocompose(ocompose(mission³, 1, mission₁), 15-2, mission₂), 27-2, mission₂)

substitute(mission³, [3,4,5], [mission₁, mission₂, mission₂]) |> display

@theory Studies(AbelianBicategoryRelations) begin
    constant(X::Ob)::(munit()→X)
    cast(X::Ob,Y::Ob)::(X → Y)
    ask(q::Question, Y::Ob, Z::Ob)::(Y→Z)
    ask!(q::Question, Y::Ob, Z::Ob)::(Y→Y⊗Z)
    # given the trajectory they followed, how many (red,green) victims did they save?
    nsaved::(Traj → Count⊗Count)
    time::(Traj → Time)

    # given the instructions from the experimenter, make a plan for playing the game
    plan::(Knowledge⊗Tool → Strategy)
    # after the first mission you have memory of the strategy you used for the previous mission
    replan::(Knowledge⊗Tool⊗Strategy → Strategy)

    # execute the playing of the game given your strategy
    play::(Strategy → Traj)
    # ask₀ is for pre-hoc questions and ask₁ is for post-hoc questions

    # ask the same question to all the participants
    question::(munit()→ Question)
end
