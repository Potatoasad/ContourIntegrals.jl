module ContourIntegrals

using QuadGK
using Cubature

abstract type Domain{d} end
abstract type Contour <: Domain{1} end

dims(x::Domain{d}) where d = d

include("LineSegment.jl")
include("SemiInfiniteLine.jl")
include("InfiniteLine.jl")
include("Contours.jl")
include("ProductDomains.jl")
include("SumDomains.jl")
include("Integration.jl")

export LineSegment, SemiInfiniteLine, InfiniteLine
export Integrate, TransformIntegrand, plot

end # module
