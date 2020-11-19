using Catlab
using Catlab.CategoricalAlgebra
using Catlab.Theories
using Catlab.Syntax
using Catlab.Present
using SocialTheories

using SQLite
using TypedTables

include("corpus.jl")
using Main.Corpus

db = SQLite.DB("db.sqlite3")

# inputs = DBInterface.execute(db, "select 
#   description as var_description,
#   CiteIt_variables.name as var_name,
#   CiteIt_vartype.name as var_type,
#   result_id, 
#   CiteIt_result.name as result_name
# from CiteIt_variables 
#   JOIN CiteIt_vartype on CiteIt_variables.typ_id == CiteIt_vartype.id 
#   JOIN CiteIt_result_indvars on variables_id == CiteIt_variables.id
#   JOIN CiteIt_result on result_id == CiteIt_result.id
# limit 100") |> Table

# outputs = DBInterface.execute(db, "select
#   description as var_description,
#   CiteIt_variables.name as var_name,
#   CiteIt_vartype.name as var_type,
#   result_id,
#   CiteIt_result.name as result_name
# from CiteIt_variables 
#   JOIN CiteIt_vartype on CiteIt_variables.typ_id == CiteIt_vartype.id 
#   JOIN CiteIt_result_depvars on variables_id == CiteIt_variables.id
#   JOIN CiteIt_result on result_id == CiteIt_result.id
# limit 100") |> Table

@show Table(db, "select * from CiteIt_variables limit 10")
#@show Table(db, "select * from CiteIt_variables join CiteIt_vartype on CiteIt_variables.typ_id == CiteIt_vartype.id limit 10")
const SocialTheory = Corpus.SocialTheory
th = SocialTheory{String}()

add_parts!(th, :Result, 2, rname=["r1", "r2"])
add_parts!(th, :Typ, 4, tname=["Ord", "Nom", "Ratio", "Interval"])
add_parts!(th, :Var, 4, typ=[1,2,1,3], name=["v1", "v2", "v3", "v4"], desc=["a", "b", "c", "d"])
add_parts!(th, :I, 3, ir=[1,1,2], iv=[1,2,2])
add_parts!(th, :D, 2, ir=[1,2], dv=[3,4])

println(th)

varnames(table) =  group(getproperty(:result_id), getproperty(:var_name), table)
@show Table(db, "select * from CiteIt_result limit 10")
@show Table(db, "select * from CiteIt_result ")

th = SocialTheory{String}()
println("Adding results")
add_results!(th, db)
@show th
println("Adding Types")
add_types!(th, db)
add_constructs!(th,db)
println("Adding variables")
add_vars!(th, db)
@show th
add_causes!(th, db)
add_effects!(th, db)

@show th

vartypename(th, v::Int) = subpart(th, subpart(th, v, :typ), :tname)
typename(th, t::Int) = subpart(th, t, :tname)
cname(th, c::Int) = subpart(th, c, :cname)
P = Presentation(FreeSymmetricMonoidalCategory)
for t in 1:nparts(th, :Typ)
    T = Symbol(typename(th, t))
    @show T
    add_generator!(P, Ob(FreeSymmetricMonoidalCategory, T))
end

hommap = Vector{Tuple{GATExpr, Int, String}}()

for r in 1:nparts(th, :Result)
    length(incident(th, r, :ir)) > 0 || continue
    typnames = Symbol.(subpart(th, subpart(th, subpart(th, incident(th, r, :ir), :iv), :typ), :tname))
    Xs = generator.(Ref(P), typnames)
    d = otimes(Xs)
    typnames = Symbol.(subpart(th, subpart(th, subpart(th, incident(th, r, :dr), :dv), :typ), :tname))
    Ys = generator.(Ref(P), typnames)
    cod = otimes(Ys)
    f = Hom(Symbol("f$r"), d, cod)
    add_generator!(P, f)
    push!(hommap,(f, r, subpart(th, r, :rname)))
end

Corpus.showsignature(P)

for homrec in hommap
    f = homrec[1]
    r = homrec[2]
    #show_variables(th, f, r)
    Corpus.show_constructs(th, f, r)
end

using Catlab.Programs
d = @program P (x::Nominal, y::Ordinal) begin
    a,b,c = f15(f1(x,y))
    d = f39(a, f36(b,c))
    return f19(d)
end
@show d