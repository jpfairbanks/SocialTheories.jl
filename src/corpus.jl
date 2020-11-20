module Corpus
using SocialTheories
using Catlab
using Catlab.Theories
using Catlab.Syntax
using Catlab.Present
using Catlab.CategoricalAlgebra
using SQLite
using TypedTables
import TypedTables: Table

using Catlab.CategoricalAlgebra

export add_results!, add_types!, add_causes!, add_constructs!, add_effects!, add_vars!,
    resultsbyinputtype, show_variables, show_constructs, showsignature

Table(db::SQLite.DB, q::String) = Table(DBInterface.execute(db, q))

function SocialTheory(db::SQLite.DB)
    th = SocialTheory{String}()
    add_results!(th, db)
    add_types!(th, db)
    add_constructs!(th,db)
    add_vars!(th, db)
    add_causes!(th, db)
    add_effects!(th, db)
    return th
end;

function add_results!(th, db)
    t = Table(db, "select * from CiteIt_result")
    add_parts!(th, :Result, length(t), rname=t.name)
    th
end

function add_types!(th, db)
    t = Table(db, "select * from CiteIt_vartype")
    add_parts!(th, :Typ, length(t)+1, tname=[t.name; "missing"])
    th
end

function add_vars!(th, db)
    t = Table(db, "select name, description as desc, typ_id as typ, construct_id as con
      from CiteIt_variables")# where typ is not null")
    t.typ .= [ismissing(t.typ[i]) ? nparts(th,:Typ) : t.typ[i] for i in 1:length(t)]
    t.con .= [ismissing(t.con[i]) ? nparts(th,:Con) : t.con[i] for i in 1:length(t)]
    add_parts!(th, :Var, length(t), name=t.name, desc=t.desc, typ=t.typ, con=t.con)
end

function add_causes!(th, db)
    t = Table(db, "select * from CiteIt_result_indvars")
    add_parts!(th, :I, length(t), ir=t.result_id, iv=t.variables_id)
end

function add_effects!(th, db)
    t = Table(db, "select * from CiteIt_result_depvars")
    add_parts!(th, :D, length(t), dr=t.result_id, dv=t.variables_id)
    th
end

function add_constructs!(th, db)
    t = Table(db, "select * from CiteIt_construct")
    add_parts!(th, :Con, maximum(t.id)+1)
    set_subpart!(th, t.id, :cname, t.name)
    set_subpart!(th, maximum(t.id)+1, :cname, "missing")
    th
end

function resultsbyinputtype(th, t::Int)
    subpart(th, collect(Base.Iterators.flatten(incident(th, incident(th, t, :typ), :iv))), :ir)
end

#######################################################
# Pretty Printing of Theories and their Presentations #
#######################################################

formatprod(xs::AbstractVector) = foldl((a,b)->"$a × $b", xs)

function show_variables(th, f::GATExpr, r::Int)
    ivs = subpart(th, incident(th, r, :ir), :iv)
    ivnames = subpart(th, ivs, :name)
    dvs = subpart(th, incident(th, r, :dr), :dv)
    dvnames = subpart(th, dvs, :name)
    println("Vars --\t$f: $(formatprod(ivnames)) → $(formatprod(dvnames))")
    return f, ivnames, dvnames
end

function show_constructs(th, f::GATExpr, r::Int)
    ivs = subpart(th, incident(th, r, :ir), :iv)
    ivnames = subpart(th, subpart(th, ivs, :con), :cname)
    dvs = subpart(th, incident(th, r, :dr), :dv)
    dvnames = subpart(th, subpart(th, dvs, :con), :cname)
    println("Cons --\t$f: $(formatprod(ivnames)) → $(formatprod(dvnames))")
    return f, ivnames, dvnames
end
showsignature(g::GATExpr) = println("Signature --\t$(g.args[1]): $(dom(g)) → $(codom(g))")

function showsignature(P::Presentation)
    print("Types: ")
    for g in generators(P)
        if isa(g, FreeSymmetricMonoidalCategory.Ob)
            show_unicode(g)
            print(", ")
        end
    end
    println()
    for g in generators(P)
        if isa(g, FreeSymmetricMonoidalCategory.Hom)
            showsignature(g)
        end
    end
end


end #module