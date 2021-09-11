struct LineSegment <: Contour
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
