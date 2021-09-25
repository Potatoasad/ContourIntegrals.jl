function Converter(f1s::Function,dims::Int)
    if dims == 1
        function f3(x,v)
            thesize = length(x)
            @inbounds for i ∈ 1:(thesize)
                #print("here")
                a = f1s(x[i])
                v[1,i] = real(a)
                v[2,i] = imag(a)
            end
        end
        return f3
    else
        function f2(x,v)
            kk = size(x)
            thesize = kk[2]
            @inbounds for i ∈ 1:(thesize)
                a = f1s(x[:,i]...)
                v[1,i] = real(a)
                v[2,i] = imag(a)
            end
        end
    return f2
    end
end

function Integrate(f::Function, C::Domain{d}; error_norm=Cubature.PAIRED, abstol=1e-10, kws...) where d
    f□ = let f=f, C=C; TransformIntegrand(f,C) end
    f□v = let f□ = f□, d=d;  Converter(f□ , d) end
    (val,err) = pcubature_v(2, f□v, zeros(d), ones(d); error_norm=error_norm, abstol=1e-10, kws...)
    val[1]+im*val[2] , sqrt(err[1]^2 + err[2]^2)
end

function Integrate(f::Function, C::SumDomain{d,p,T}; error_norm=Cubature.PAIRED,abstol=1e-10,kws...) where {d,p,T}
    valt = ComplexF64(0.0);
    errt = Float64(0.0);
    for i ∈ 1:p
        val,error = Integrate(f,C.domains[i]; error_norm=Cubature.PAIRED, abstol=1e-10, kws...)
        valt += val
        errt += error^2
    end
    val, sqrt(errt)
end
