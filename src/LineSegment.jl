struct LineSegment <: Contour
    z0::Complex{Float64}
    z1::Complex{Float64}
    orientation::Bool
end

ϕ⁺(C::LineSegment) = let z1=C.z1, z0=C.z0; s -> s*(z1-z0)+z0 end
Jac⁺(C::LineSegment) = let z1=C.z1, z0=C.z0; s -> (z1-z0) end
