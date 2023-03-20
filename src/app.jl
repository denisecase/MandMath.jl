#=

App module

This is the main entry point for the MandArt package.

    Examples

    ```julia
    julia> using MandArt
    julia> App.run()
    ```

Auhor:  Denise M Case
Date:   2023-03-18

=#
module App

using Logging

include("./reader.jl")

const LOG_FOLDER = "logs"
const LOG_FILE = "log.txt"
const LOG_INFO_FILE = "loginfo.txt"
const LOG_WARN_FILE = "logwarn.txt"

export run

function run(args::Vector{String}=ARGS)
    @info "App.run: called."
    log_dir = joinpath(@__DIR__, "..", LOG_FOLDER)
    if !isdir(log_dir)
        mkdir(log_dir)
    end
    log_file_path = joinpath(log_dir, LOG_FILE)
    io = nothing
    try
        io = open(log_file_path, "w+")
    catch e
        @error "App.run: ERROR opening log file: $e"
        exit()
    end
    try
        log = Logging.SimpleLogger(io)
        #global_logger(log)
    catch e
        @error "App.run: ERROR creating loggers: $e"
        exit()
    end

     if isempty(args) || length(args) == 0
         try
           Reader.read_urls_from_file()
           Reader.process_directory()
         catch e
            @error "App.run: ERROR accessing $Reader.DATA_FOLDER or $Reader.DATA_URL_FILE or file: $e"
            if io !== nothing
                close(io)
            end
         end
    else
        @info "App.run: Processing argss: $args"
        input_fp = args[1]
        @info "App.run: Processing args input file path: $input_fp"
        Reader.process_file(input_fp)
    end

    if io !== nothing
        close(io)
    end

    @info "App.run: completed."
end

if isfile(@__FILE__)
    App.run(ARGS)
end

end
