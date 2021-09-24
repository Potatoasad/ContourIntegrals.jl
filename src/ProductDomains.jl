struct ProductDomain{d,p,T} <: Domain{d}
    domains::T
end

ProductDomain(x::Tuple) = ProductDomain{sum(dims.(x)),length(x),typeof(x)}(x)

⊗(x::Domain,y::Domain) =  ProductDomain((x,y))
⊗(x::ProductDomain,y::Domain) =  ProductDomain((x.domains...,y))
⊗(x::Domain,y::ProductDomain) =  ProductDomain((x,y.domains...))


function definebunch(varnames,varexps)
    expr = Expr(:block)
    for i ∈ 1:length(varnames)
       push!(expr.args,Expr(:(=),varnames[i],varexps[i]))
    end
    expr
end

collectexpr(x) = Expr(:block, vcat([xi.args for xi ∈ x]...)...)

function makefinalfunc(func,ϕname,Jname,domainname,N)
    func1 = [:($ϕname($domainname[$i])) for i ∈ 1:N]
    vals1 = [Symbol("$(ϕname)$(n)") for n ∈ 1:N]

    func2 = [:($Jname($domainname[$i])) for i ∈ 1:N]
    vals2 = [Symbol("$(Jname)$(n)") for n ∈ 1:N]

    a1 = collectexpr([definebunch(vals1,func1),definebunch(vals2,func2)])
    a2 = makefunc(func,vals1,vals2,N)
    Expr(:block,[a1,a2]...)
end

function makefunc(func,ϕnames,jacnames,N)
    vars = [Symbol("x$(n)") for n ∈ 1:N];
    tuplehead = Expr(:tuple, vars...)
    jacs = [:($(jacnames[i])($(vars[i]))) for i ∈ 1:N]
    args = [:($(ϕnames[i])($(vars[i]))) for i ∈ 1:N]
    funccall = :($(func)($(args...)))
    exprs = Expr(:call,:*,funccall,jacs...)
    Expr(:->,tuplehead, exprs)
end

macro ConstructFunc(func,ϕname,Jname,domainname,N)
   esc(makefinalfunc(func,ϕname,Jname,domainname,N))
end


function TransformIntegrand(f::Function, C::ProductDomain{d,p,T}) where {d,p,T}
    doms = C.domains;
    if d == 1
        g = let f=f,ϕ=ϕ,Jac=Jac, doms=doms, p=d
           @ConstructFunc(f,ϕ,Jac,doms,1)
        end
        return g
    else
        if d==2
            g = let f=f,ϕ=ϕ,Jac=Jac, doms=doms, p=d
               @ConstructFunc(f,ϕ,Jac,doms,2)
            end
            return g
        elseif d==3
            g = let f=f,ϕ=ϕ,Jac=Jac, doms=doms, p=d
               @ConstructFunc(f,ϕ,Jac,doms,3)
            end
            return g
        elseif d==4
            g = let f=f,ϕ=ϕ,Jac=Jac, doms=doms, p=d
               @ConstructFunc(f,ϕ,Jac,doms,4)
            end
            return g
        elseif d==5
            g = let f=f,ϕ=ϕ,Jac=Jac, doms=doms, p=d
               @ConstructFunc(f,ϕ,Jac,doms,5)
            end
            return g
        else
            error("How many dimensions do you want?")
        end
    end
end
