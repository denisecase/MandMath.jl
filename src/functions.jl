"""
functions.jl is a Julia file for defining functions for MandMath.jl.

"""

# Combinatorics is a Julia package for doing combinatorics
# and formatting large numbers
using Combinatorics
using Printf
using JSON
using HTTP
using Glob

# export public facing functions so they can be used in MandMath.jl
export greet
export get_grid
export get_grid_inputs
export process_file_or_url
export GridInputs

struct GridInputs
    imageWidth::Int
    imageHeight::Int
    xCenter::BigFloat
    yCenter::BigFloat
    scale::BigFloat
    iterationsMax::Float64
    rSqLimit::Float64
    dFIterMin::Float64
    theta::Float64
    yY::Float64

    function GridInputs(; imageWidth::Int = 1200, imageHeight::Int = 1000, xCenter::Union{BigFloat,Float64} = BigFloat(-0.75), yCenter::Union{BigFloat,Float64} = BigFloat(0.0), scale::BigFloat = BigFloat(430.0), iterationsMax::Float64 = 10000.0, rSqLimit::Float64 = 400.0, dFIterMin::Float64 = 0.0, theta::Float64 = 0.0, yY::Float64 = 0.0)
        new(imageWidth, imageHeight, xCenter, yCenter, scale, iterationsMax, rSqLimit, dFIterMin, theta, yY)
    end
end



function get_grid_inputs(data::Dict)
    imageWidth = get(data, "imageWidth", 800)
    imageHeight = get(data, "imageHeight", 800)
    xCenter = get(data, "xCenter", -0.5)
    yCenter = get(data, "yCenter", 0.0)
    scale = get(data, "scale", 1.0)
    iterationsMax = get(data, "iterationsMax", 1000.0)
    rSqLimit = get(data, "rSqLimit", 4.0)
    dFIterMin = get(data, "dFIterMin", 1.0)
    theta = get(data, "theta", 0.0)
    yY = get(data, "yY", 0.0)
    return GridInputs(imageWidth, imageHeight, xCenter, yCenter, scale, iterationsMax, rSqLimit, dFIterMin, theta, yY)
end


function process_file_or_url(input)
        # temporarily disable this function for testing purposes
        if false
            return
        end
    # Check if input is a filename or URL
    if occursin("http://", input) || occursin("https://", input)
        # Read the JSON data from the URL
        response = HTTP.get(input)
        data = JSON.parse(String(response.body))
        inputs = get_grid_inputs(data)
        grid = get_grid(inputs)
    else
        # Check if input is a file or directory
        if isfile(input)
            # Check if file has .mandart extension
            if occursin(".mandart", input)
                # Read the JSON data from the file
                data = JSON.parsefile(input)
                inputs = get_grid_inputs(data)
                grid = get_grid(inputs)
            end
        elseif isdir(input)
            # Process all .mandart files in directory recursively
            for file in Glob.glob(joinpath(input, "**/*.mandart"))
                # Check if file has .mandart extension
                if occursin(".mandart", file)
                    # Read the JSON data from the file
                    data = JSON.parsefile(file)
                    inputs = get_grid_inputs(data)
                    grid = get_grid(inputs)
                end
            end
        end
    end
end

# define simple greet function for testing
function greet()
    return """
    Welcome to MandMath!
    We'll use this to create a Julia executable.
    We can use 150 decimal places for X and Y.
    """
end

function get_grid(inputs::GridInputs)

    w, h = inputs.imageWidth, inputs.imageHeight
    xCenter, yCenter, scale = inputs.xCenter, inputs.yCenter, inputs.scale

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

