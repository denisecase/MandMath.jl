"""
functions.jl is a Julia file for defining functions for MandMath.jl.

"""

# Combinatorics is a Julia package for doing combinatorics
# and formatting large numbers
import CSV
import Glob
import HTTP
import JSON
import Logging
import LoggingExtras
import Printf
import Tables

# export public facing functions so they can be tested and used
export arrays_equal
export get_grid
export get_grid_inputs
export greet
export GridInputs
export main
export process_file_or_url
export write_grid_to_csv

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

    function GridInputs(; imageWidth::Int=IMAGE_WIDTH_DEFAULT, imageHeight::Int=IMAGE_HEIGHT_DEFAULT, xCenter::Union{BigFloat,Float64}=X_CENTER_DEFAULT, yCenter::Union{BigFloat,Float64}=Y_CENTER_DEFAULT, scale::BigFloat=SCALE_DEFAULT, iterationsMax::Float64=ITERATIONS_MAX_DEFAULT, rSqLimit::Float64=R_SQ_LIMIT_DEFAULT, dFIterMin::Float64=DF_ITER_MIN_DEFAULT, theta::Float64=THETA_DEFAULT, yY::Float64=YY_DEFAULT)
        new(imageWidth, imageHeight, xCenter, yCenter, scale, iterationsMax, rSqLimit, dFIterMin, theta, yY)
    end
end

function arrays_equal(array1::Array{Float64,2}, array2::Array{Float64,2})
    size(array1) == size(array2) || return false
    for i in eachindex(array1)
        if array1[i] != array2[i]
            return false
        end
    end
    return true
end

function greet()
    return "Welcome to MandMath!"
end

function get_grid(inputs::GridInputs)
    w, h = inputs.imageWidth, inputs.imageHeight
    xCenter, yCenter, scale = inputs.xCenter, inputs.yCenter, inputs.scale

    wmin, wmax = 4, 10000
    hmin, hmax = 4, 10000
    xmin, xmax = -2.0, 2.0
    ymin, ymax = -2.0, 2.0
    scalemin, scalemax = 1.0, 1.0e100

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

    grid = Array{Float64}(undef, w, h)
    for i in 1:w, j in 1:h
        grid[i, j] = 1.24 + rand() * (567.83 - 1.24)
    end
    return grid
end

function get_grid_inputs(data::Dict)
    imageWidth = Int(get(data, "imageWidth", IMAGE_WIDTH_DEFAULT))
    imageHeight = Int(get(data, "imageHeight", IMAGE_HEIGHT_DEFAULT))
    xCenter = BigFloat(get(data, "xCenter", X_CENTER_DEFAULT))
    yCenter = BigFloat(get(data, "yCenter", Y_CENTER_DEFAULT))
    scale = BigFloat(get(data, "scale", SCALE_DEFAULT))
    iterationsMax = Float64(get(data, "iterationsMax", ITERATIONS_MAX_DEFAULT))
    rSqLimit = Float64(get(data, "rSqLimit", R_SQ_LIMIT_DEFAULT))
    dFIterMin = Float64(get(data, "dFIterMin", DF_ITER_MIN_DEFAULT))
    theta = Float64(get(data, "theta", THETA_DEFAULT))
    yY = Float64(get(data, "yY", YY_DEFAULT))
    return GridInputs(; imageWidth, imageHeight, xCenter, yCenter, scale, iterationsMax, rSqLimit, dFIterMin, theta, yY)
end

function is_url(input)
    return occursin("http://", input) || occursin("https://", input) ? true : false
end

function process_file_or_url(input)
    @info "functions.process_file_or_url() called with $input."
    if is_url(input)
        @info "Reading from input URL: $input"
        response = HTTP.get(input)
        try
            data = JSON.parse(String(response.body))
            inputs = get_grid_inputs(data)
            grid = get_grid(inputs)
            #  MandMath.write_grid_to_csv(grid, input)
        catch e
            if isa(e, JSON.ParserError)
                @error "Response from the URL is not valid JSON. Might be HTML or other format."
            else
                rethrow()
            end
        end

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
                MandMath.write_grid_to_csv(grid, input)
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
                    MandMath.write_grid_to_csv(grid, file)
                end
            end
        end
    end
    @info "functions.process_file_or_url() completed."
end

function read_urls_from_file(filename::String)
    if isfile(filename)
        urls = readlines(filename)
        return urls
    else
        error("File with document urls ($filename) does not exist.")
    end
end

function write_grid_to_csv(input_filename::String, grid::Array{Float64,2})
    @info "functions.write_grid_to_csv() called with $input_filename."
    base_name = basename(input_filename)
    base_name_without_ext = splitext(base_name)[1]
    output_file_basename = joinpath(base_name_without_ext * ".csv")
    @info "functions.write_grid_to_csv() writing to $output_file_basename."
    output_dir = joinpath(@__DIR__, "..", "output")
    if !isdir(output_dir)
        Base.mkdir(output_dir)
    end
    output_file = joinpath(output_dir, output_file_basename)    
    @info "functions.write_grid_to_csv() writing to $output_file."
    table = Tables.table(grid)
    CSV.write(output_file, table, header=false)
end

function main(args::Vector{String}=ARGS)
    @info "MandMath.main() called."
    println(greet())
    log_dir = joinpath(@__DIR__, "..", "logs")
    if !isdir(log_dir)
        Base.mkdir(log_dir)
    end
    log_info = joinpath(log_dir, "loginfo.txt")
    log_warn = joinpath(log_dir, "logwarn.txt")
    logger = LoggingExtras.TeeLogger(
        LoggingExtras.MinLevelLogger(LoggingExtras.FileLogger(log_info), Logging.Info),
        LoggingExtras.MinLevelLogger(LoggingExtras.FileLogger(log_warn), Logging.Warn),
    )
    Logging.global_logger(logger)

    # If no input file/url is provided, read from urls.txt and process all files
    if isempty(args) || length(args) == 0
        try
            urls_file = joinpath(@__DIR__, "..", "data", "urls.txt")
            urls = read_urls_from_file(urls_file)
            for url in urls
                print("Processing URL: ", url)
                process_file_or_url(url)
            end
            for file in Glob.glob("**/*.mandart")
                if occursin(".mandart", file)
                    print("Processing file: ", file)
                    process_file_or_url(file)
                end
            end
        catch e
            @error "An error occurred: $e"
            exit(1)
        end

    else
        # Process the specified file/url provided in the args
        input = args[1]
        print("Processing args input: ", input)
        process_file_or_url(input)
    end
    @info "MandMath.main() completed."
end

# execute some code if this file is run directly
if isfile(@__FILE__)
    main(ARGS)
end
