import Plots.plot

function plot(func,contour::Contour; kwargs...)
    f = TransformIntegrand(func,contour)
    p = plot(x -> real(func(x)),[0,1]; kwargs...)
    plot!(p,x -> imag(func(x)),[0,1]; kwargs...)
    display(p)
end
