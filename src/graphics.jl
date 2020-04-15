using Catlab

using Catlab.Doctrines
using Catlab.Syntax

using Convex, SCS, TikzPictures
using Compose: draw, PGF
using Catlab.Graphics
using Catlab.Graphics.ComposeWiringDiagrams

using Catlab.WiringDiagrams
import Catlab.WiringDiagrams: to_hom_expr

wd(x) = to_wiring_diagram(x)
#display(x) = to_composejl(add_junctions!(wd(x)), direction=:horizontal, labels=true)
viz(x::WiringDiagram) = to_graphviz(add_junctions(x), orientation=LeftToRight, labels=true)
viz(x) = draw(to_wiring_diagram(x))

#compile_expr(f, name=:acc_train, args=[:query], arg_types=[:Query])
moduleof(p::Presentation) = typeof(first(generators(p))).name.module
to_hom_expr(p::Presentation, f::WiringDiagram) = to_hom_expr(moduleof(p), f)

render(P::Presentation, d::WiringDiagram) = to_composejl(to_hom_expr(P, d),rounded_boxes=true)

pgfrender(io::IO, P, d) =begin
    pic = render(P,d)
    pgf_backend = PGF(io, pic.width, pic.height,
    false, # emit_on_finish
    true,  # only_tikz
    texfonts=true)
    draw(pgf_backend, pic.context)
end

tikzrender(P::Presentation, d::WiringDiagram) = to_tikz(to_hom_expr(P, d),rounded_boxes=false)

tikzrender(io::IO, P, d) =begin
    pic = tikzrender(P,d)
    Graphics.TikZ.pprint(io, pic)
end
