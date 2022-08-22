@testset "Output Correct Values over different Domains" begin
L = LineSegment(0.0,2π,true)
@test Integrate(x -> sin(x)^2,L)[1] |> real ≈ π

Semi = SemiInfiniteLine(0,1,true)
@test Integrate(x -> exp(-x^2),Semi)[1] |> real ≈ 0.886226925452758

Full = InfiniteLine(0,1,true)
@test Integrate(x -> exp(-x^2),Full)[1] |> real ≈ 1.772453850905516

@test Integrate(x -> exp(im*x),SemiInfiniteLine(0,1*im,true))[1] |> imag ≈ 1
end