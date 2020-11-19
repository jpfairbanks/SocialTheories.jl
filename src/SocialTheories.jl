module SocialTheories

greet() = print("Hello ASIST World!")

using Catlab
using Catlab.Theories

export viz, pgfrender, tikzrender, wd, SocialFacilitation, ArousalAnxietyFacilitation, Studies, Satisficing, Sat

include("types.jl")
include("stochexpr.jl")
include("operad.jl")
include("graphics.jl")
include("corpus.jl")

include("socialfacilitation.jl")
include("metacognition.jl")
include("missions.jl")
include("satisficing.jl")

end # module