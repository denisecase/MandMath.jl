"""
functions.jl is a Julia file for defining functions for MandMath.jl.

"""

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
export greet
export main
export process_file_or_url
export write_grid_to_csv

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
            inputs = MandMath.get_grid_inputs(data)
            grid = MandMath.get_grid(inputs)
            MandMath.write_grid_to_csv(grid, input)
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
            if occursin(DATA_FILE_EXTENTION, input)
                # Read the JSON data from the file
                data = JSON.parsefile(input)
                inputs = MandMath.get_grid_inputs(data)
                grid = MandMath.get_grid(inputs)
                MandMath.write_grid_to_csv(grid, input)
            end
        elseif isdir(input)
            @info "Reading from input DIRECTORY: $input"
            # Process all .mandart files in directory recursively
            for file in Glob.glob(joinpath(input, "**/*.mandart"))
                # Check if file has .mandart extension
                if occursin(DATA_FILE_EXTENTION, file)
                    # Read the JSON data from the file
                    data = JSON.parsefile(file)
                    inputs = MandMath.get_grid_inputs(data)
                    grid = MandMath.get_grid(inputs)
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
    base_name_without_ext = splitext(basename(input_filename))[1]
    output_file_basename = joinpath(base_name_without_ext * OUT_FILE_EXT)
    @info "functions.write_grid_to_csv() writing to $output_file_basename."
    output_dir = joinpath(@__DIR__, "..", OUTPUT_FOLDER)
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
    println(MandMath.greet())
    log_dir = joinpath(@__DIR__, "..", LOG_FOLDER)
    @info "log_dir = $log_dir"
    if !isdir(log_dir)
        Base.mkdir(log_dir)
    end
    log_file_path = joinpath(log_dir, LOG_FILE)
    io = Base.open(log_file_path, "w+")
    try
        log = Logging.SimpleLogger(io)
        @info "Logger initialized."

        #logger = Logging.global_logger(log)
        #@info "Set global logger $logger."

    catch e
        @error "ERROR creating loggers: $e"
        exit()
    end
    @info "Loggers initialized."

    # If no input file/url is provided, read from urls.txt and process all files
    if isempty(args) || length(args) == 0
        try
            @info "No args provided. Reading from $DATA_URL_FILE and $DATA_FOLDER."
            url_fp = joinpath(@__DIR__, "..", DATA_FOLDER, DATA_URL_FILE)
            urls = read_urls_from_file(url_fp)
            for url in urls
                @info "Processing URL: $url"
                process_file_or_url(url)
            end
            for file_path in Glob.glob("**/*.mandart")
                @info "Processing file: $file_path"
                process_file_or_url(file_path)
            end
        catch e
            @error "ERROR accessing $DATA_URL_FILE or $DATA_FOLDER file: $e"
            if io !== nothing
                close(io)
            end
        end
    else
        @info "Processing args input: $args"
        input_fp = args[1]
        print("Processing input: ", input_fp)
        process_file_or_url(input_fp)
    end
    if io !== nothing
        close(io)
    end
    @info "MandMath.main() completed."
end

# execute some code if this file is run directly
if isfile(@__FILE__)
    main(ARGS)
end
