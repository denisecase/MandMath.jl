"""
functions.jl is a Julia file for defining functions for MandMath.jl.

"""

# Combinatorics is a Julia package for doing combinatorics
# and formatting large numbers
using Combinatorics
using Printf


# export public facing functions so they can be used in MandMath.jl
export greet
export get_grid

# define simple greet function for testing
function greet()
    return """
    Welcome to MandMath!
    We'll use this to create a Julia executable.
    We can use 150 decimal places for X and Y.
    """
end

#=
 define an initial get grid function for testing
 if not provided, it will default to Float64, 
 so we'll allow either a BigFloat or Float64, or Nothing
 The semicolon ; is used in Julia to separate positional arguments 
 from keyword arguments. It is used to indicate the end of the 
 positional arguments and the beginning of the keyword arguments. 
 Any argument after the semicolon is considered a keyword argument. 
 This allows users to write functions with optional positional arguments 
 followed by required keyword arguments.
=#
function get_grid(; w::Int64 = 1200, h::Int64 = 1000, xCenter::Union{BigFloat, Float64, Nothing} = nothing, 
    yCenter::Union{BigFloat, Float64, Nothing} = nothing, 
    scale::Union{BigFloat, Float64, Nothing} = nothing)

    if xCenter == nothing
        xCenter = -0.75
    end
    if yCenter == nothing
        yCenter = 0.0
    end
    if scale == nothing
        scale = 430.0
    end

    # Define the bounds for each of the inputs

    wmin, wmax = 4, 10000
    hmin, hmax = 4, 10000
    xmin, xmax = -2.0, 2.0
    ymin, ymax = -2.0, 2.0
    scalemin, scalemax = 1.0, 1.0e100

    # Check if the inputs are within acceptable bounds

    if w < wmin || w > wmax
        error("image width, w, must be between $wmin and $wmax pixels.")
    end
    if h < hmin || h > hmax
        error("image height, h, must be between $hmin and $hmax pixels.")
    end
    if xCenter < xmin || xCenter > xmax
        error("Starting X must be between $xmin and $xmax.")
    end
    if yCenter < ymin || yCenter > ymax
        error("Starting Y must be between $ymin and $ymax.")
    end
    if scale < scalemin || scale > scalemax
        error("Scale must be between $scalemin and $scalemax.")
    end

    #=
     Create a grid of points from w and height
     each element is initialized to 1. 
     Populate the grid with random numbers between 1.24 and 567.83
     =#
    grid = ones(Float64, w, h)
    grid = fill(0.0, w, h)
    for i in 1:w, j in 1:h
        grid[i, j] = 1.24 + rand() * (567.83 - 1.24)
    end

    println("xCenter is $xCenter")
    println("yCenter is $yCenter")


    formatted_scale = @sprintf("%.1e", scale)
    println("scale is $formatted_scale")

    c = complex(xCenter, yCenter)
    println("c is $c")

    return grid
end

