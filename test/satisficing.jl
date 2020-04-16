model = @program Satisficing (g::Goal, m::Mission) begin
    asp = aspirations(g)
    presh = timepressure(m)
    tend = popST()
    s = satisficing(asp, presh, tend)
    return goalscomm(asp), difftriage(s), nasatlx(presh), stinv(tend)
end

isdiagram(model)

hypoth₁ = @program Satisficing () begin
    b₁ = gt(aspirations(goal1()), aspirations(goal2()))
    b₂ = gt(timepressure(mission1()), timepressure(mission2()))
    return and(b₁, b₂)
end

isdiagram(hypoth₁)

hypoth₂ = @program Satisficing (asp1::Number, asp2::Number) begin
    b₃ = gt(asp1,asp2)
    st = popST()
    presh = univariate()

    b₄ = lt(satisficing(asp1, presh, st), satisficing(asp2, presh, st))
    return and(b₃, b₄)
end

isdiagram(hypoth₂)

hypoth₃ = @program Satisficing (st1::Number, st2::Number) begin
    b₃ = gt(st1,st2)
    asp = univariate()
    presh = univariate()

    b₄ = gt(satisficing(asp, presh, st1), satisficing(asp, presh, st2))
    return and(b₃, b₄)
end

isdiagram(hypoth₃)

hypoth₄ = @program Satisficing (presh1::Number, presh2::Number) begin
    b₃ = gt(presh1,presh2)
    asp = univariate()
    st = popST()

    b₄ = gt(satisficing(asp, presh1, st), satisficing(asp, presh2, st))
    return and(b₃, b₄)
end

# for any mission setting goal1 will have lower DifferentiatedTriaging than goal 2
hypoth = @program Satisficing (m::Mission) begin
    g1 = goal1()
    g2 = goal2()
    asp = aspirations(g1)
    presh = timepressure(m)
    tend = popST()
    s = satisficing(asp, presh, tend)
    x = (goalscomm(asp), difftriage(s), nasatlx(presh), stinv(tend))

    asp = aspirations(g2)
    presh = timepressure(m)
    tend = popST()
    s = satisficing(asp, presh, tend)
    y = (goalscomm(asp), difftriage(s), nasatlx(presh), stinv(tend))

    return lt(x[2], y[2])
end

# we can apply the rules of CartesianCategories to reduce this diagram to a simpler form.
# if you don't measure it and it doesn't cause anything you measure, then it doesn't exist.
# for any mission setting goal1 will have lower DifferentiatedTriaging than goal 2
hypoth = @program Satisficing (m::Mission) begin
    g1 = goal1()
    g2 = goal2()
    asp = aspirations(g1)
    presh = timepressure(m)
    tend = popST()
    s = satisficing(asp, presh, tend)
    x = difftriage(s)

    asp = aspirations(g2)
    presh = timepressure(m)
    tend = popST()
    s = satisficing(asp, presh, tend)
    y = difftriage(s)

    return lt(x, y)
end


# for any goal, mission1 will have higher DifferentiatedTriaging than mission2
hypoth = @program Satisficing (g::Goal) begin
    m1 = mission1()
    m2 = mission2()

    asp = aspirations(g)
    presh = timepressure(m1)
    tend = popST()
    s = satisficing(asp, presh, tend)
    x = difftriage(s)

    asp = aspirations(g)
    presh = timepressure(m2)
    tend = popST()
    s = satisficing(asp, presh, tend)
    y = difftriage(s)

    return gt(x, y)
end

# we can combine these hypotheses into the mega hypoth
# for any mission setting goal1 will have lower DifferentiatedTriaging than goal 2
# for any goal, mission1 will have higher DifferentiatedTriaging than mission2
hypoth = @program Satisficing () begin
    g1 = goal1()
    g2 = goal2()
    m = mission1()
    asp = aspirations(g1)
    presh = timepressure(m)
    tend = popST()
    s = satisficing(asp, presh, tend)
    x = difftriage(s)

    asp = aspirations(g2)
    presh = timepressure(m)
    tend = popST()
    s = satisficing(asp, presh, tend)
    y = difftriage(s)

    b₁ = lt(x, y)

    g1 = goal1()
    g2 = goal2()
    m = mission2()
    asp = aspirations(g1)
    presh = timepressure(m)
    tend = popST()
    s = satisficing(asp, presh, tend)
    x = difftriage(s)

    asp = aspirations(g2)
    presh = timepressure(m)
    tend = popST()
    s = satisficing(asp, presh, tend)
    y = difftriage(s)

    b₄ = lt(x, y)

    m1 = mission1()
    m2 = mission2()
    g = goal1()
    asp = aspirations(g)
    presh = timepressure(m1)
    tend = popST()
    s = satisficing(asp, presh, tend)
    x = difftriage(s)

    asp = aspirations(g)
    presh = timepressure(m2)
    tend = popST()
    s = satisficing(asp, presh, tend)
    y = difftriage(s)

    b₂ = gt(x, y)

    m1 = mission1()
    m2 = mission2()
    g = goal2()
    asp = aspirations(g)
    presh = timepressure(m1)
    tend = popST()
    s = satisficing(asp, presh, tend)
    x = difftriage(s)

    asp = aspirations(g)
    presh = timepressure(m2)
    tend = popST()
    s = satisficing(asp, presh, tend)
    y = difftriage(s)

    b₃ = gt(x, y)
    return and(and(b₁, b₂), and(b₃, b₄))
end

hypothₐ = @program Sat (g::Goal, m::Mission) begin
    return sat(g,m)
end
isdiagram(hypothₐ)

hypoth⁺ₐ = @program Sat () begin
    g1 = goal1()
    g2 = goal2()
    m1 = mission1()
    m2 = mission2()
    and(and(lt(sat(g1,m1), sat(g2, m1)), lt(sat(g1,m2), sat(g1,m2))),
        and(gt(sat(g1,m1), sat(g1, m2)), gt(sat(g2,m1), sat(g2,m2))))
end

isdiagram(hypoth⁺ₐ)

# it looks like you need 8 experimental conditions in order to test this hypotheses,
# but you can rewrite it to use fewer.
# With this formulation of the expression, you can use only 4 experimental conditions
# to test the hypothesis.
hypoth⁺ₐ = @program Sat () begin
    g1 = goal1()
    g2 = goal2()
    m1 = mission1()
    m2 = mission2()

    s11 = sat(g1,m1)
    s21 = sat(g2,m1)
    s12 = sat(g1,m2)
    s22 = sat(g2,m2)

    and(and(lt(s11, s21), lt(s12, s22)),
        and(gt(s11, s12), gt(s21, s22)))
end

isdiagram(hypoth⁺ₐ)
