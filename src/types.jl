using Catlab
using Catlab.CategoricalAlgebra
using Catlab.Theories
using Catlab.Present
import Catlab.Present.Presentation

export TheoryTheories, NamedTheory, SocialTheory

@present TheoryTheories(FreeSchema) begin
  Result::Ob
  I::Ob
  D::Ob
  Var::Ob
  Typ::Ob
  Con::Ob

  ir::Hom(I,Result)
  iv::Hom(I,Var)
  dr::Hom(D,Result)
  dv::Hom(D,Var)
  typ::Hom(Var, Typ)
  con::Hom(Var, Con)
end

@present NamedTheory <: TheoryTheories begin
  Str::Data
  rname::Attr(Result, Str)
  name::Attr(Var, Str)
  desc::Attr(Var, Str)
  tname::Attr(Typ, Str)
  cname::Attr(Con, Str)
end

const SocialTheory = ACSetType(NamedTheory, index=[:ir, :iv, :dr, :dv, :typ])

"""    rename(s)

the `@program` macro expects the object and hom names of a presentation to be symbols without spaces or hyphens.
"""
rename(s) = Symbol(replace(replace(s, " "=>"_"), "-"=>"_"))

"""    add_objects!(p::Presentation, th::SocialTheory)

add all constructs from `th` to the presentation `p` as object generators.
"""
function add_objects!(p::Presentation, th::SocialTheory)
  for i in 1:nparts(th, :Con)
    try
        T = rename(subpart(th, i, :cname))
        add_generator!(p, Ob(FreeCartesianCategory, T))
    catch UndefVarError
        println("INFO: undefined name for construct $i")
    end 
  end
end

"""    add_homs!(p::Presentation, th::SocialTheory)

add all results from `th` to the presentation `p` as hom generators. The domain is the monoidal product 
of the independent variables, the codomain is the monoidal product of the depedent variables.
"""
function add_homs!(p::Presentation, th::SocialTheory)
  for r in 1:nparts(th, :Result)
    length(incident(th, r, :ir)) > 0 || continue
    typnames = rename.(subpart(th, subpart(th, subpart(th, incident(th, r, :ir), :iv), :con), :cname))
    Xs = generator.(Ref(p), typnames)
    d = otimes(Xs)
    typnames = rename.(subpart(th, subpart(th, subpart(th, incident(th, r, :dr), :dv), :con), :cname))
    Ys = generator.(Ref(p), typnames)
    cod = otimes(Ys)
    f = Hom(Symbol("f$r"), d, cod)
    add_generator!(p, f)
  end
end


"""    Presentation!(th::SocialTheory)

contructs a FreeCartesianCategory representing the social theory. The Homs represent causal processes and the objects represent constructs. 
Free Cartesian Categories are monoidal categories with copying. This allows the wiring diagrams over `Presentation(th)` to split wires.
In the `@program` syntax, this correspondes to reading from a variable multiple times, like

```julia
@program P (x::X) begin
  return f(x), g(x)
```

which would encode the stochastic process of sampling from `P(y|x)×P(z∣x)`. 
"""
function Presentation(th::SocialTheory)
  P = Presentation(FreeCartesianCategory)
  add_objects!(P, th)
  add_homs!(P,th)
  return P
end