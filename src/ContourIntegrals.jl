module ContourIntegrals

using QuadGK

abstract type Contour end

include("LineSegment.jl")
include("SemiInfiniteLine.jl")
include("InfiniteLine.jl")

function Integrate(func,contour; rtol=1e-8)
    f = TransformIntegrand(func,contour)
    integral,error = quadgk(f,0,1,rtol=rtol)
end

export LineSegment, SemiInfiniteLine, InfiniteLine
export Integrate, TrasformIntegrand

end # module
