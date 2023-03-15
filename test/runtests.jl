using MandMath
using Test

include("../src/MandMath.jl")
include("../src/functions.jl")

@testset "MandMath Tests" begin


@testset "MandMath.jl greet() " begin
    @test startswith(MandMath.greet(), "Welcome to MandMath!")
    @test MandMath.greet() != "Hello world!"
    @test MandMath.greet() != "Hello MandMath...."
end

@testset "MandMath get_grid function" begin


@testset "get_grid default arguments" begin
    grid = MandMath.get_grid()
    @test typeof(grid) == Array{Float64, 2}
    @test size(grid) == (1200, 1000)
end

@testset "get_grid given xCenter and yCenter" begin
    xInput::BigFloat = 1.2345678901234567890123456789012345678901234567890123456789012345678901234567890
    yInput::BigFloat = 0.8765432109876543210987654321098765432109876543210987654321098765432109876543210
    scaleInput::BigFloat = 123123123.0
    grid = MandMath.get_grid(xCenter = xInput, yCenter = yInput, scale = scaleInput)  
    @test typeof(grid) == Array{Float64, 2}
    @test size(grid) == (1200, 1000)
end


@testset "get_grid XY with 150 decimal places" begin
    xInput::BigFloat = 1.2345678901234567890123456789012345678901234567890123456789012345678901234567890
    yInput::BigFloat = 0.8765432109876543210987654321098765432109876543210987654321098765432109876543210
    scaleInput::BigFloat = 123123123.0
    grid = MandMath.get_grid(xCenter = xInput, yCenter = yInput, scale = scaleInput)  
    @test typeof(grid) == Array{Float64, 2}
    @test size(grid) == (1200, 1000)
end

end # end testset "MandMath get_grid function"

end # end testset "MandMath Tests"

