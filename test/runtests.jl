import CSV
import Coverage
import DelimitedFiles
import HTTP
import Logging
import LoggingExtras

using JSON
using MandMath
using Test

@testset "MandMath Tests" begin

    @testset "arrays_equal" begin

        @testset "Identical arrays" begin
            a1 = [
                1.1 2.2
                3.3 4.4
            ]
            a2 = [
                1.1 2.2
                3.3 4.4
            ]
            @test MandMath.arrays_equal(a1, a2)
        end

        @testset "Different values" begin
            a1 = [
                1.1 2.2
                3.3 4.4
            ]
            a2 = [
                1.1 2.2
                3.3 5.5
            ]
            @test !MandMath.arrays_equal(a1, a2)
        end

        @testset "Different dimensions" begin
            a1 = [
                1.1 2.2
                3.3 4.4
            ]
            a2 = [
                1.1 2.2 3.3
                4.4 5.5 6.6
            ]
            @test !MandMath.arrays_equal(a1, a2)
        end

        @testset "Empty arrays" begin
            a1 = Array{Float64,2}(undef, 0, 0)
            a2 = Array{Float64,2}(undef, 0, 0)
            @test MandMath.arrays_equal(a1, a2)
        end

    end

    @testset "greet" begin
        @test startswith(MandMath.greet(), "Welcome to MandMath!")
        @test MandMath.greet() != "Hello world!"
        @test MandMath.greet() != "Hello MandMath...."
    end

    @testset "get_grid" begin

        @testset "all defaults" begin
            input = MandMath.GridInputs()
            grid = MandMath.get_grid(input)
            @test typeof(grid) == Array{Float64,2}
            @test size(grid) == (1200, 1000)
        end

        @testset "given x, y, scale" begin
            xInput = parse(BigFloat, "1.2345678901234567890123456789012345678901234567890123456789012345678901234567890")
            yInput = parse(BigFloat, "0.8765432109876543210987654321098765432109876543210987654321098765432109876543210")
            scaleInput = parse(BigFloat, "123123123.0")
            input = MandMath.GridInputs(xCenter=xInput, yCenter=yInput, scale=scaleInput)
            grid = MandMath.get_grid(input)
            @test typeof(grid) == Array{Float64,2}
            @test size(grid) == (1200, 1000)
        end


        @testset "big x, y, scale" begin
            xInput = parse(BigFloat, "1.2345678901234567890123456789012345678901234567890123456789012345678901234567890")
            yInput = parse(BigFloat, "0.8765432109876543210987654321098765432109876543210987654321098765432109876543210")
            scaleInput = parse(BigFloat, "123123123.0")
            input = MandMath.GridInputs(xCenter=xInput, yCenter=yInput, scale=scaleInput)
            grid = MandMath.get_grid(input)
            @test typeof(grid) == Array{Float64,2}
            @test size(grid) == (1200, 1000)
        end

    end

    @testset "get_grid_inputs" begin

        @testset "given empty dict" begin

            data = Dict()
            grid_inputs = MandMath.get_grid_inputs(data)
            @test grid_inputs.imageWidth == MandMath.IMAGE_WIDTH_DEFAULT
            @test grid_inputs.imageHeight == MandMath.IMAGE_HEIGHT_DEFAULT
            @test grid_inputs.xCenter == MandMath.X_CENTER_DEFAULT
            @test grid_inputs.yCenter == MandMath.Y_CENTER_DEFAULT
            @test grid_inputs.scale == MandMath.SCALE_DEFAULT
            @test grid_inputs.iterationsMax == MandMath.ITERATIONS_MAX_DEFAULT
            @test grid_inputs.rSqLimit == MandMath.R_SQ_LIMIT_DEFAULT
            @test grid_inputs.dFIterMin == MandMath.DF_ITER_MIN_DEFAULT
            @test grid_inputs.theta == MandMath.THETA_DEFAULT
            @test grid_inputs.yY == MandMath.YY_DEFAULT
        end

        @testset "given x, scale, theta" begin

            data = Dict("xCenter" => -0.5, "scale" => 2.0, "theta" => 0.785)
            grid_inputs = MandMath.get_grid_inputs(data)
            @test grid_inputs.imageWidth == MandMath.IMAGE_WIDTH_DEFAULT
            @test grid_inputs.imageHeight == MandMath.IMAGE_HEIGHT_DEFAULT
            @test grid_inputs.xCenter == -0.5
            @test grid_inputs.yCenter == MandMath.Y_CENTER_DEFAULT
            @test grid_inputs.scale == 2.0
            @test grid_inputs.iterationsMax == MandMath.ITERATIONS_MAX_DEFAULT
            @test grid_inputs.rSqLimit == MandMath.R_SQ_LIMIT_DEFAULT
            @test grid_inputs.dFIterMin == MandMath.DF_ITER_MIN_DEFAULT
            @test grid_inputs.theta == 0.785
            @test grid_inputs.yY == MandMath.YY_DEFAULT

        end

        @testset "given full dict" begin

            data = Dict("imageWidth" => 800, "imageHeight" => 600, "xCenter" => -0.5, "yCenter" => 0.0,
                "scale" => 1.0, "iterationsMax" => 500, "rSqLimit" => 4.0, "dFIterMin" => 0.0001,
                "theta" => 1.57, "yY" => 0.0)
            grid_inputs = MandMath.get_grid_inputs(data)
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

    @testset "process_file_or_url" begin

        urls = ["https://raw.githubusercontent.com/denisecase/MandArt-Discoveries/main/brucehjohnson/Rectangle1.mandart",
            "https://raw.githubusercontent.com/denisecase/MandArt-Discoveries/main/brucehjohnson/Rectangle2.mandart",
            "https://raw.githubusercontent.com/denisecase/MandArt-Discoveries/main/denisecase/Opening.mandart"
        ]

        jsons = [
            """{"id":"6DA3A777-0C94-423F-AD08-A98F43F31010","scale":250000000000000,"huesOptimizedForPrinter":[],"yCenter":0.098118137903386804,"imageWidth":1000,"nImage":0,"spacingColorFar":5,"hues":[{"r":0,"id":"76A27A6A-17B5-43DA-9480-40E5DA818B05","num":1,"g":255,"b":0,"color":{"red":0,"green":0.99999994039535522,"blue":0}},{"r":255,"id":"429D31F0-DF8B-4C3F-8BAD-E346455C32FA","num":2,"g":255,"b":0,"color":{"red":0.99999994039535522,"green":0.99999994039535522,"blue":0}},{"r":255,"id":"1084366D-C794-4405-9543-0C44DBAED6AD","num":3,"g":0,"b":0,"color":{"red":0.99999994039535522,"green":0,"blue":0}},{"r":255,"id":"E8FC9AF2-BC41-49E3-9B16-61D6D0CA61E2","num":4,"g":0,"b":255,"color":{"red":0.99999994039535522,"green":0,"blue":0.99999994039535522}},{"r":0,"id":"16375FA5-D917-49CB-BC0B-CF3AF2A03B6C","num":5,"g":0,"b":255,"color":{"red":0,"green":0,"blue":0.99999994039535522}},{"r":0,"id":"6464F2F2-062A-4A67-8423-1B1763DA6D9B","num":6,"g":255,"b":255,"color":{"red":0,"green":0.99999994039535522,"blue":0.99999994039535522}}],"leftNumber":1,"theta":32,"rSqLimit":400,"iterationsMax":10000,"yY":0,"dFIterMin":0,"spacingColorNear":15,"imageHeight":1000,"nBlocks":60,"xCenter":0.37861651612441594,"huesEstimatedPrintPreview":[]}""",
            """{"id":"6DA3A777-0C94-423F-AD08-A98F43F31010","scale":350000000000000,"huesOptimizedForPrinter":[],"yCenter":0.098118137903386804,"imageWidth":1000,"nImage":0,"spacingColorFar":5,"hues":[{"r":0,"id":"76A27A6A-17B5-43DA-9480-40E5DA818B05","num":1,"g":255,"b":0,"color":{"red":0,"green":0.99999994039535522,"blue":0}},{"r":255,"id":"429D31F0-DF8B-4C3F-8BAD-E346455C32FA","num":2,"g":255,"b":0,"color":{"red":0.99999994039535522,"green":0.99999994039535522,"blue":0}},{"r":255,"id":"1084366D-C794-4405-9543-0C44DBAED6AD","num":3,"g":0,"b":0,"color":{"red":0.99999994039535522,"green":0,"blue":0}},{"r":255,"id":"E8FC9AF2-BC41-49E3-9B16-61D6D0CA61E2","num":4,"g":0,"b":255,"color":{"red":0.99999994039535522,"green":0,"blue":0.99999994039535522}},{"r":0,"id":"16375FA5-D917-49CB-BC0B-CF3AF2A03B6C","num":5,"g":0,"b":255,"color":{"red":0,"green":0,"blue":0.99999994039535522}},{"r":0,"id":"6464F2F2-062A-4A67-8423-1B1763DA6D9B","num":6,"g":255,"b":255,"color":{"red":0,"green":0.99999994039535522,"blue":0.99999994039535522}}],"leftNumber":1,"theta":32,"rSqLimit":400,"iterationsMax":10000,"yY":0,"dFIterMin":0,"spacingColorNear":15,"imageHeight":1000,"nBlocks":60,"xCenter":0.37861651612441594,"huesEstimatedPrintPreview":[]}""",
            """{"id":"D7D0117D-4A1F-4DCD-95E9-53487CF11636","scale":430,"huesOptimizedForPrinter":[],"yCenter":0,"imageWidth":1100,"nImage":0,"spacingColorFar":5,"hues":[{"r":0,"id":"0EFCEFA3-0F0F-41F2-BE1C-D2158FDF11E0","num":1,"g":255,"b":0,"color":{"red":0,"green":0.99999994039535522,"blue":0}},{"r":255,"id":"57450628-D46B-4B02-A1DE-E05714C07D7B","num":2,"g":255,"b":0,"color":{"red":0.99999994039535522,"green":0.99999994039535522,"blue":0}},{"r":255,"id":"F68C8BC0-A9FE-44BB-AAF1-A3563BCA5DA6","num":3,"g":0,"b":0,"color":{"red":0.99999994039535522,"green":0,"blue":0}},{"r":255,"id":"E70E0E60-13BC-4CAA-A5B2-9F3DE7C5E821","num":4,"g":0,"b":255,"color":{"red":0.99999994039535522,"green":0,"blue":0.99999994039535522}},{"r":0,"id":"1D8150A2-C9E2-4F81-B968-242D5AFC9355","num":5,"g":0,"b":255,"color":{"red":0,"green":0,"blue":0.99999994039535522}},{"r":0,"id":"3DFFA52E-C24D-4196-8C87-29C567492CFF","num":6,"g":255,"b":255,"color":{"red":0,"green":0.99999994039535522,"blue":0.99999994039535522}}],"leftNumber":1,"theta":0,"rSqLimit":400,"iterationsMax":10000,"yY":0,"dFIterMin":0,"spacingColorNear":15,"imageHeight":1000,"nBlocks":60,"xCenter":-0.75,"huesEstimatedPrintPreview":[]}"""
        ]

        for i in 1:3
            @testset "given mandart url $i" begin
                function test_process_file_or_url_url_input()
                    url = urls[i]
                    mock_response = jsons[i]
                    HTTP.mock(200, mock_response)
                    grid = MandMath.process_file_or_url(url)
                    HTTP.unmock()
                    @test typeof(grid) == Grid
                end
            end
        end

        @testset "given input directory" begin
            function test_process_file_or_url_directory_input()
                dir_path = "data/brucehjohnson"
                grid = MandMath.process_file_or_url(dir_path)
                @test typeof(grid) == Grid
            end
        end

        @testset "given input file" begin
            function test_process_file_or_url_file_input()
                file_path = "data/denisecase/Opening.mandart"
                grid = MandMath.process_file_or_url(file_path)
                @test typeof(grid) == Grid
            end
        end
    end

    @testset "read_urls_from_file" begin

        @testset "Existing file" begin
            test_file = joinpath(@__DIR__, "..", "data", "urls.txt")
            # Make sure you create this file and populate it with sample URLs before running the test
            urls = MandMath.read_urls_from_file(test_file)
            @test length(urls) > 0
        end

        @testset "Non-existing file" begin
            test_file = joinpath(@__DIR__, "..", "data", "non_existent_file.txt")
            @test_throws Exception read_urls_from_file(test_file)
        end

    end

    @testset "write_grid_to_csv" begin

        @testset "Test 1: Check if the CSV file is created with the correct name" begin
            input_file = joinpath(@__DIR__, "..", "data", "brucehjohnson", "Rectangle1.mandart")
            grid4x3 = Array{Float64,2}([
                1.0 2.0 3.0
                4.0 5.0 6.0
                7.0 8.0 9.0
                10.0 11.0 12.0
            ])
            MandMath.write_grid_to_csv(input_file, grid4x3)
            base_name_without_ext = splitext(basename(input_file))[1]
            output_file_basename = joinpath(base_name_without_ext * ".csv")
            output_dir = joinpath(@__DIR__, "..", "output")
            if !isdir(output_dir)
                Base.mkdir(output_dir)
            end
            output_file = joinpath(output_dir, output_file_basename) 
            @test isfile(output_file)
            rm(output_file)  # Cleanup the test file
        end

        @testset "Test 2: Check if the CSV file contains the correct data" begin
            input_file = joinpath(@__DIR__, "..", "data", "brucehjohnson", "Rectangle2.mandart")
            grid4x2 = Array{Float64,2}([
                1.0 2.0
                4.0 5.0
                7.0 8.0
                10.0 11.0
            ])
            MandMath.write_grid_to_csv(input_file, grid4x2)
            base_name_without_ext = splitext(basename(input_file))[1]
            output_file_basename = joinpath(base_name_without_ext * ".csv")
            output_dir = joinpath(@__DIR__, "..", "output")
            if !isdir(output_dir)
                Base.mkdir(output_dir)
            end
            output_file = joinpath(output_dir, output_file_basename) 
            @test isfile(output_file)
            data = DelimitedFiles.readdlm(output_file, ',', Float64)
            output_grid = reshape(data, 4, 2)
            for i in 1:4, j in 1:2
                @test grid4x2[i, j] ≈ output_grid[i, j]
                atol = 1e-14
                rtol = 1e-14
            end
            rm(output_file)  # Cleanup the test file
        end

    end

end
