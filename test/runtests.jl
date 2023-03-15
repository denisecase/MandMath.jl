using MandMath
using Test

@testset "MandMath Tests" begin

@testset "MandMath.jl greet() " begin
    @test startswith(MandMath.greet(), "Welcome to MandMath!")
    @test MandMath.greet() != "Hello world!"
    @test MandMath.greet() != "Hello MandMath...."
end

@testset "MandMath get_grid function" begin


    @testset "get_grid default arguments" begin
        input = MandMath.GridInputs()
        grid = get_grid(input)
        @test typeof(grid) == Array{Float64, 2}
        @test size(grid) == (1200, 1000)
    end

    @testset "get_grid given xCenter and yCenter" begin
        xInput = parse(BigFloat, "1.2345678901234567890123456789012345678901234567890123456789012345678901234567890")
        yInput = parse(BigFloat, "0.8765432109876543210987654321098765432109876543210987654321098765432109876543210")
        scaleInput = parse(BigFloat, "123123123.0")
        input = MandMath.GridInputs(xCenter = xInput, yCenter = yInput, scale = scaleInput)
        grid = get_grid(input)  
        @test typeof(grid) == Array{Float64, 2}
        @test size(grid) == (1200, 1000)
    end


    @testset "get_grid XY with 150 decimal places" begin
        xInput = parse(BigFloat, "1.2345678901234567890123456789012345678901234567890123456789012345678901234567890")
        yInput = parse(BigFloat, "0.8765432109876543210987654321098765432109876543210987654321098765432109876543210")
        scaleInput = parse(BigFloat, "123123123.0")
        input = MandMath.GridInputs(xCenter = xInput, yCenter = yInput, scale = scaleInput)
        grid = get_grid(input)  
        @test typeof(grid) == Array{Float64, 2}
        @test size(grid) == (1200, 1000)
    end

end # end testset "MandMath get_grid function"

end # end testset "MandMath Tests"

