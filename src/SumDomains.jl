struct SumDomain{d,p,T} <: Domain{d}
    domains::T
end

function SumDomain(x::Tuple)
    dimensions = dims.(x)
    if all(isequal(dimensions[1]),dimensions)
        return SumDomain{dims(x[1]),length(x),typeof(x)}(x)
    else
        return error("The domains must have equal dimension")
    end
end

⊕(x::Domain,y::Domain) =  SumDomain((x,y))
⊕(x::SumDomain,y::Domain) =  SumDomain((x.domains...,y))
⊕(x::Domain,y::SumDomain) =  SumDomain((x,y.domains...))

using MacroTools

function UnrollSplatfunc(expr,var,num_args)
    symlist = collect(Symbol("s$(i)") for i ∈ 1:num_args)
    args = join(("s$(i)" for i ∈ 1:num_args),",") |> Meta.parse
    exp0 = MacroTools.postwalk(x -> @capture(x, g_($(var)...)) ? Expr(:call,g,symlist...) : x, expr)
    exp1 = MacroTools.postwalk(x -> @capture(x, ($(var)...)) ? args : x, exp0)
    exp2 = MacroTools.postwalk(x -> (@capture(x, ($(var)[i_])) && (i isa Integer)) ? symlist[i] : x, exp1)
    exp2
end
macro UnrollSplat(expr,var,num_args)
    esc(UnrollSplatfunc(expr,var,num_args))
end

function TransformIntegrand(f::Function, C::SumDomain{d,p,T}) where {d,p,T}
    funcs = map(c->TransformIntegrand(f,c),C.domains);
    if d == 1
        g = let fs=funcs, p=p
           x -> fs[Int64((p*x+1) ÷ 1)](x)
        end
        return g
    else
        if d==2
            g = let fs=funcs, p=p
               @UnrollSplat((x...)->fs[Int64((p*x[1]+1) ÷ 1)](x...),x,2)
            end
            return g
        elseif d==3
            g = let fs=funcs, p=p
               @UnrollSplat((x...)->fs[Int64((p*x[1]+1) ÷ 1)](x...),x,3)
            end
            return g
        elseif d==4
            g = let fs=funcs, p=p
               @UnrollSplat((x...)->fs[Int64((p*x[1]+1) ÷ 1)](x...),x,4)
            end
            return g
        elseif d==5
            g = let fs=funcs, p=p
               @UnrollSplat((x...)->fs[Int64((p*x[1]+1) ÷ 1)](x...),x,5)
            end
            return g
        elseif d==6
            g = let fs=funcs, p=p
               @UnrollSplat((x...)->fs[Int64((p*x[1]+1) ÷ 1)](x...),x,6)
            end
            return g
        else
            error("How many dimensions do you want?")
        end
    end
end
