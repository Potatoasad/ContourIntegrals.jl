struct SemiInfiniteLine <: Contour
    z0::Complex{Float64}
    z1::Complex{Float64}
    FromPointToInfinity::Bool
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
