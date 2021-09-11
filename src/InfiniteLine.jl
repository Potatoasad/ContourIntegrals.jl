struct InfiniteLine <: Contour
    z0::Complex{Float64}
    z1::Complex{Float64}
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
