Orientϕ(ϕ1::Function, orient::Bool) =  orient ? ϕ1 : t->ϕ1(1-t)
OrientJac(J1::Function, orient::Bool) = orient ? J1 : t->-J1(1-t)

ϕ(C::Contour) = Orientϕ(ϕ⁺(C),C.orientation)
Jac(C::Contour) = OrientJac(Jac⁺(C),C.orientation)

function TransformIntegrand(f::Function, C::Contour)
    let ϕs = ϕ(C), Js = Jac(C)
       t -> f(ϕs(t))*Js(t)
    end
end
