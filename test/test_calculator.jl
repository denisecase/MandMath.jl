
using .Calculator
using Test

include("../src/writer.jl")

test_imageWidth = Int(400)
test_imageHeight = Int(400)
test_xCenter = BigFloat(0.0)
test_yCenter = BigFloat(0.0)
test_scale = BigFloat(4.0)
test_iterationsMax = Float64(100.0)
test_rSqLimit = Float64(400.0)
test_dFIterMin = Float64(0.0)
test_theta = Float64(0.0)
test_yY = Float64(0.0)
test_inputs = GridInputs(imageWidth=test_imageWidth, 
                    imageHeight=test_imageHeight, 
                    xCenter=test_xCenter, 
                    yCenter=test_yCenter, 
                    scale=test_scale, 
                    iterationsMax=test_iterationsMax, 
                    rSqLimit=test_rSqLimit, 
                    dFIterMin=test_dFIterMin, 
                    theta=test_theta, 
                    yY=test_yY)

@testset "Calculator module tests" begin
    @testset "get_grid function tests" begin
        grid = Calculator.get_grid(test_inputs)
        @test size(grid) == (test_imageWidth, test_imageHeight)
    end
    @testset "get_grid_inputs function tests" begin
        data = Dict("imageWidth" => test_imageWidth, "imageHeight" => test_imageHeight, "xCenter" => test_xCenter, "yCenter" => test_yCenter, "scale" => test_scale, "iterationsMax" => test_iterationsMax, "rSqLimit" => test_rSqLimit, "dFIterMin" => test_dFIterMin, "theta" => test_theta, "yY" => test_yY)
        inputs = Calculator.get_grid_inputs(data)
        @test inputs == test_inputs
    end
end


@testset "get_grid" begin

    @testset "all defaults" begin
        input = Calculator.GridInputs()
        grid = Calculator.get_grid(input)
        @test typeof(grid) == Array{Float64,2}
        @test size(grid) == (1200, 1000)
    end

    @testset "normal x, y, scale" begin
        xInput = parse(BigFloat, "1.2345678901234567")
        yInput = parse(BigFloat, "0.8765432109876543")
        scaleInput = parse(BigFloat, "123123123.0")
        input = Calculator.GridInputs(xCenter=xInput, yCenter=yInput, scale=scaleInput)
        grid = Calculator.get_grid(input)
        @test typeof(grid) == Array{Float64,2}
        @test size(grid) == (1200, 1000)
    end

    @testset "bigFloat x, y, scale" begin
        xInput = parse(BigFloat, "1.2345678901234567890123456789012345678901234567890123456789012345678901234567890")
        yInput = parse(BigFloat, "0.8765432109876543210987654321098765432109876543210987654321098765432109876543210")
        scaleInput = parse(BigFloat, "123123123.0")
        input = Calculator.GridInputs(xCenter=xInput, yCenter=yInput, scale=scaleInput)
        grid = Calculator.get_grid(input)
        @test typeof(grid) == Array{Float64,2}
        @test size(grid) == (1200, 1000)
    end

end

@testset "get_grid_inputs" begin

    @testset "given empty dict" begin
        data = Dict()
        grid_inputs = Calculator.get_grid_inputs(data)
        @test grid_inputs.imageWidth == Calculator.IMAGE_WIDTH_DEFAULT
        @test grid_inputs.imageHeight == Calculator.IMAGE_HEIGHT_DEFAULT
        @test grid_inputs.xCenter == Calculator.X_CENTER_DEFAULT
        @test grid_inputs.yCenter == Calculator.Y_CENTER_DEFAULT
        @test grid_inputs.scale == Calculator.SCALE_DEFAULT
        @test grid_inputs.iterationsMax == Calculator.ITERATIONS_MAX_DEFAULT
        @test grid_inputs.rSqLimit == Calculator.R_SQ_LIMIT_DEFAULT
        @test grid_inputs.dFIterMin == Calculator.DF_ITER_MIN_DEFAULT
        @test grid_inputs.theta == Calculator.THETA_DEFAULT
        @test grid_inputs.yY == Calculator.YY_DEFAULT
    end

    @testset "given x, scale, theta" begin
        data = Dict("xCenter" => -0.5, "scale" => 2.0, "theta" => 0.785)
        grid_inputs = Calculator.get_grid_inputs(data)
        @test grid_inputs.imageWidth == Calculator.IMAGE_WIDTH_DEFAULT
        @test grid_inputs.imageHeight == Calculator.IMAGE_HEIGHT_DEFAULT
        @test grid_inputs.xCenter == -0.5
        @test grid_inputs.yCenter == Calculator.Y_CENTER_DEFAULT
        @test grid_inputs.scale == 2.0
        @test grid_inputs.iterationsMax == Calculator.ITERATIONS_MAX_DEFAULT
        @test grid_inputs.rSqLimit == Calculator.R_SQ_LIMIT_DEFAULT
        @test grid_inputs.dFIterMin == Calculator.DF_ITER_MIN_DEFAULT
        @test grid_inputs.theta == 0.785
        @test grid_inputs.yY == Calculator.YY_DEFAULT
    end

    @testset "given full dict" begin
        data = Dict("imageWidth" => 800, "imageHeight" => 600, "xCenter" => -0.5, "yCenter" => 0.0,
            "scale" => 1.0, "iterationsMax" => 500, "rSqLimit" => 4.0, "dFIterMin" => 0.0001,
            "theta" => 1.57, "yY" => 0.0)
        grid_inputs = Calculator.get_grid_inputs(data)
        @test grid_inputs.imageWidth == 800
        @test grid_inputs.imageHeight == 600
        @test grid_inputs.xCenter == -0.5
        @test grid_inputs.yCenter == 0.0
        @test grid_inputs.scale == 1.0
        @test grid_inputs.iterationsMax == 500
        @test grid_inputs.rSqLimit == 4.0
        @test grid_inputs.dFIterMin == 0.0001
        @test grid_inputs.theta == 1.57
        @test grid_inputs.yY == 0.0
    end

end
