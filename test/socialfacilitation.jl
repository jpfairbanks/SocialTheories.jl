sfmodel = @program SocialFacilitation (task::Task) begin
    a = observed()
    t = task
    s₁ = perform(t, a)
    s₂ = perform(t, neg(a))
    return neq(s₁, s₂)
end

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

# Refinement Functor ArousalAnxietyFacilitation => SocialFacilitation
# (arousal⊗anxiety)⋅performance ↦ perform,
# < ↦ !=
# > ↦ !=
# identity everywhere else
# any model of SocialFacilitation is a model of ArousalAnxietyFacilitation

begin
    ArousalAnxietyFacilitation = deepcopy(SocialFacilitation)
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

isdiagram(sfmodel)
isdiagram(ttmodel)
isdiagram(aamodel)
