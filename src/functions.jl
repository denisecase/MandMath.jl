"""
functions.jl is a Julia file for defining functions for MandMath.jl.

"""

# Combinatorics is a Julia package for doing combinatorics
# and formatting large numbers
import Combinatorics
import Printf
import JSON
import HTTP
import Glob

# export public facing functions so they can be used in MandMath.jl
export greet
export get_grid
export get_grid_inputs
export process_file_or_url
export GridInputs

export IMAGE_WIDTH_DEFAULT
export IMAGE_HEIGHT_DEFAULT 
export X_CENTER_DEFAULT
export Y_CENTER_DEFAULT 
export SCALE_DEFAULT 
export ITERATIONS_MAX_DEFAULT 
export R_SQ_LIMIT_DEFAULT 
export DF_ITER_MIN_DEFAULT
export THETA_DEFAULT 
export YY_DEFAULT 

# Define constants
IMAGE_WIDTH_DEFAULT = 1200
IMAGE_HEIGHT_DEFAULT = 1000
X_CENTER_DEFAULT = BigFloat(-0.75)
Y_CENTER_DEFAULT = BigFloat(0.0)
SCALE_DEFAULT = BigFloat(430.0)
ITERATIONS_MAX_DEFAULT = 10000.0
R_SQ_LIMIT_DEFAULT = 400.0
DF_ITER_MIN_DEFAULT = 0.0
THETA_DEFAULT = 0.0
YY_DEFAULT = 0.0

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

    function GridInputs(; imageWidth::Int = IMAGE_WIDTH_DEFAULT, imageHeight::Int = IMAGE_HEIGHT_DEFAULT, xCenter::Union{BigFloat,Float64} = X_CENTER_DEFAULT, yCenter::Union{BigFloat,Float64} = Y_CENTER_DEFAULT, scale::BigFloat = SCALE_DEFAULT, iterationsMax::Float64 = ITERATIONS_MAX_DEFAULT, rSqLimit::Float64 = R_SQ_LIMIT_DEFAULT, dFIterMin::Float64 = DF_ITER_MIN_DEFAULT, theta::Float64 = THETA_DEFAULT, yY::Float64 = YY_DEFAULT)
        new(imageWidth, imageHeight, xCenter, yCenter, scale, iterationsMax, rSqLimit, dFIterMin, theta, yY)
    end
end

function get_grid_inputs(data::Dict)
    @info "functions.get_grid_inputs() called."
    imageWidth = get(data, "imageWidth", IMAGE_WIDTH_DEFAULT)
    imageHeight = get(data, "imageHeight", IMAGE_HEIGHT_DEFAULT)
    xCenter = BigFloat(get(data, "xCenter", X_CENTER_DEFAULT))
    yCenter = BigFloat(get(data, "yCenter",Y_CENTER_DEFAULT))
    scale = BigFloat(get(data, "scale", SCALE_DEFAULT))
    iterationsMax = Float64(get(data, "iterationsMax", ITERATIONS_MAX_DEFAULT))
    rSqLimit = get(data, "rSqLimit", R_SQ_LIMIT_DEFAULT)
    dFIterMin = get(data, "dFIterMin", DF_ITER_MIN_DEFAULT)
    theta = get(data, "theta", THETA_DEFAULT)
    yY = get(data, "yY", YY_DEFAULT)
    @info "functions.get_grid_inputs() before returning GridInputs."
    return GridInputs(; imageWidth, imageHeight, xCenter, yCenter, scale, iterationsMax, rSqLimit, dFIterMin, theta, yY)
end


function process_file_or_url(input)
    @info "functions.process_file_or_url() called."
    # Check if input is a filename or URL
    if occursin("http://", input) || occursin("https://", input)
        # Read the JSON data from the URL
        @info "Reading from input URL: $input"
        response = HTTP.get(input)
        data = JSON.parse(String(response.body))
        inputs = get_grid_inputs(data)
        grid = get_grid(inputs)
        #@info "grid is $grid"
    else
        # Check if input is a file or directory
        if isfile(input)
            @info "Reading from input FILE: $input"
            # Check if file has .mandart extension
            if occursin(".mandart", input)
                # Read the JSON data from the file
                data = JSON.parsefile(input)
                inputs = get_grid_inputs(data)
                grid = get_grid(inputs)
            end
        elseif isdir(input)
            @info "Reading from input DIRECTORY: $input"
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
    @info(file_logger, Logging.Info, "functions.process_file_or_url() completed.")
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
    @info "functions.get_grid() called."

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

    println("scale is $scale")

    c = complex(xCenter, yCenter)
    println("c is $c")

    @info "functions.get_grid() completed. Returning grid."
    return grid
end


function show_opening()
    @info "show_opening called."
    io = open("log.txt", "w+")
    logger = SimpleLogger(io)
    global_logger(logger)
    @info "MandMath.jl loaded successfully."
  end
  
  function show_closing()
    @info "MandMath.jl completed successfully."
    close(io)
  end
  
  function main(ARGS)
    @info "MandMath.main() called."
    # If no input file/url is provided, read from urls.txt and process all files
    if length(ARGS) == 0
      # Read URLs from urls.txt and process each one
      urls = readlines("data/urls.txt")
      for url in urls
        print("Processing URL: ", url)
        # process_file_or_url(url)
      end
      # Process all .mandart files in local data directory recursively
      for file in Glob.glob("**/*.mandart")
        if occursin(".mandart", file)
          print("Processing file: ", file)
            #process_file_or_url(file)
        end
      end
    else
      # Process the specified file/url provided in the args
      input = ARGS[1]
      print("Processing args input: ", input)
      #process_file_or_url(input)
    end
    @info(file_logger, Logging.Info, "MandMath.main() completed.")
  end
  
  # execute some code if this file is run directly
  if isfile(@__FILE__)
    @info "MandMath.jl loaded successfully."
    println(greet())
    main(ARGS)
    @info "MandMath.jl completed successfully."
  end
  
