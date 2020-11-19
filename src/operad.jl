using Catlab.WiringDiagrams

export oapply

"""    sortedinwires(ws::Vector)

the wires incident to a box in a WiringDiagram are not guaranteed to be sorted by port number so we provide this helper function
"""
sortedinwires(ws::Vector) = map(w->w.source, sort(ws, by=w->w.target.port))

"""    sortedinwires(d::WiringDiagram, i::Int)

sorts the input wires of the i-th box of `d`.
"""
sortedinwires(d::WiringDiagram, i::Int) = sortedinwires(in_wires(d, i))

"""    outports(d::WiringDiagram, i::Int)

returns an iterator over the output_ports of the i-th box of `d`
"""
outports(d::WiringDiagram,i::Int) = [Port(i, OutputPort, p) for p in 1:length(output_ports(d, i))]

"""    setvalues!(values, y, outputs)

analogous to `values[outputs] .= y`, but for dictionaries
"""
setvalues!(values, y, outputs) = for p in outputs
    values[p] = y[p.port]
end

"""    getvalues(values, inputs)

analogous to `x = values[inputs]`, but for dictionaries
"""
getvalues(values, inputs) = [values[i] for i in inputs]

"""    oapply(d::WiringDiagram, distributions::Dict)

treating `distributions` as a Dictionary mapping box names to Markov Kernals, constructs the composit Markov Kernal you get
by plugging in `distributions[f]` for every appearance of `f` as a box in `d`. This implements an algebra of the operad of directed 
wiring diagrams for callables in Julia.

See `Catlab.WiringDiagrams.ocompose` for more information about operadic composition.
"""
function oapply(d::WiringDiagram, distributions::Dict)
    ordering = topological_sort(d)
    values = Dict{Port, Float64}()
    function sample(parameters)
        setvalues!(values, parameters, outports(d,1))
        for i in ordering
            boxname = boxes(d)[i-2].value
            p = distributions[boxname]
            x = getvalues(values, sortedinwires(d,i))
            y = p(x)
            setvalues!(values, y, outports(d,i))
        end
        return getvalues(values, sortedinwires(d,2))
    end
    return sample
end