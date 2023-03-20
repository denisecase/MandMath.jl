using Test
using MandMath
using MandMath.Calculator
using MandMath.Reader
using MandMath.Writer

include("test_calculator.jl")
include("test_reader.jl")
include("test_writer.jl")

@testset "All tests" begin
    @testset "Calculator tests" begin
        include("test_calculator.jl")
    end
    @testset "Reader tests" begin
        include("test_reader.jl")
    end
    @testset "Writer tests" begin
        include("test_writer.jl")
    end
end