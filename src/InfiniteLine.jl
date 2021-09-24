struct InfiniteLine <: Contour
    z0::Complex{Float64}
    z1::Complex{Float64}
    orientation::Bool
end

ignoreat0and1(t,a) = (t >= 1.0-2*eps(Float64)) ? 1.0-2*eps(Float64) : ((t <= 2*eps(Float64)) ? 2*eps(Float64) : a)

ϕ⁺(C::InfiniteLine) = let z1=C.z1, z0=C.z0
    t -> ignoreat0and1(t,((1-2*t)/(4*t*(t-1)))*(z1-z0)+z0)
end

Jac⁺(C::InfiniteLine) = let z1=C.z1, z0=C.z0
    t -> ignoreat0and1(t,(z1-z0)*((1-2*t+2*t^2)/(4*((t-1)^2)*t^2)))
end
