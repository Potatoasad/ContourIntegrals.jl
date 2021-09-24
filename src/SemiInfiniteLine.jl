struct SemiInfiniteLine <: Contour
    z0::Complex{Float64}
    z1::Complex{Float64}
    orientation::Bool
end

ϕ⁺(C::SemiInfiniteLine) = t -> begin
    a = ((t/(1-t))*(C.z1-C.z0)+C.z0);
    (t >= 1.0-2*eps(Float64)) ? 1.0-2*eps(Float64) : a
end

Jac⁺(C::SemiInfiniteLine) = t -> begin
    a = (C.z1-C.z0)/(1-t)^2;
    (t >= 1.0-2*eps(Float64)) ? 1.0-2*eps(Float64) : a
end
