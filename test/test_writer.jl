using .Writer
using DelimitedFiles
using Test

@testset "Writer module tests" begin

    @testset "Writer.write_grid_to_csv function tests" begin

        @testset "Test 1: Check if the CSV file is created with the correct name" begin
            input_file = joinpath(@__DIR__, "..", "data", "brucehjohnson", "Rectangle1.mandart")
            grid4x3 = Array{Float64,2}([
                1.0 2.0 3.0
                4.0 5.0 6.0
                7.0 8.0 9.0
                10.0 11.0 12.0
            ])
            Writer.write_grid_to_csv(grid4x3,input_file)
            base_name_without_ext = splitext(basename(input_file))[1]
            output_file_basename = joinpath(base_name_without_ext * Writer.OUT_FILE_EXT)
            output_dir = joinpath(@__DIR__, "..", Writer.OUTPUT_FOLDER)
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
            Writer.write_grid_to_csv( grid4x2,input_file,)
            base_name_without_ext = splitext(basename(input_file))[1]
            output_file_basename = joinpath(base_name_without_ext * Writer.OUT_FILE_EXT)
            output_dir = joinpath(@__DIR__, "..", Writer.OUTPUT_FOLDER)
            if !isdir(output_dir)
                Base.mkdir(output_dir)
            end
            output_file = joinpath(output_dir, output_file_basename)
            @test isfile(output_file)
            data = DelimitedFiles.readdlm(output_file, ',', Float64)
            output_grid = reshape(data, 4, 2)
            for i in 1:4, j in 1:2
                @test isapprox(grid4x2[i, j], output_grid[i, j], atol=1e-14, rtol=1e-14)
            end
            rm(output_file)  # Cleanup the test file
        end

    end
end