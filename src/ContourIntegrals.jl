module ContourIntegrals

using QuadGK

abstract type Contour end

include("LineSegment.jl")
include("SemiInfiniteLine.jl")
include("InfiniteLine.jl")
include("Integration.jl")

export LineSegment, SemiInfiniteLine, InfiniteLine
export Integrate, TrasformIntegrand, plot

end # module
