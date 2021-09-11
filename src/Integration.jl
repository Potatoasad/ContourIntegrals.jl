
function Integrate(func,contour; rtol=1e-8, atol=0.0)
    f = TransformIntegrand(func,contour)
    integral,error = quadgk(f,0,1;rtol=rtol, atol=atol)
end
