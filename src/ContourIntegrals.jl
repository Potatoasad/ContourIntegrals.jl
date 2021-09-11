module ContourIntegrals

using QuadGK

abstract type Contour end

struct LineSegment <: Contour
    z0::Complex{Float64}
    z1::Complex{Float64}
end

struct SemiInfiniteLine <: Contour
    z0::Complex{Float64}
    z1::Complex{Float64}
    FromPointToInfinity::Bool
end

struct InfiniteLine <: Contour
    z0::Complex{Float64}
    z1::Complex{Float64}
end

function TransformIntegrand(func,contour::LineSegment)
    f = let z0=contour.z0; z1=contour.z1
    function NewIntegrand(s)
            func(s*(z1-z0)+z0)*(z1-z0)
    end
    end
    f
end

function TransformIntegrand(func,contour::SemiInfiniteLine)
    if contour.FromPointToInfinity
        corr = 1.0
    else
        corr = -1.0
    end
    f = let z0=contour.z0, z1=contour.z1, corr = corr
    function NewIntegrand(t)
            corr*func((t/(1-t))*(z1-z0)+z0)*(z1-z0)/(1-t)^2
    end
    end
    f
end

function TransformIntegrand(func,contour::InfiniteLine)
    f = let z0=contour.z0; z1=contour.z1
    function NewIntegrand(t)
            a1 = (1-2*t)/(4*t*(t-1))
            a2 = (1-2*t+2*t^2)/(4*((t-1)^2)*t^2)
            func(a1*(z1-z0)+z0)*(z1-z0)*a2
    end
    end
    f
end

function Integrate(func,contour; rtol=1e-8)
    f = TransformIntegrand(func,contour)
    integral,error = quadgk(f,0,1,rtol=rtol)
end



export Integrate, TrasformIntegrand

end # module
