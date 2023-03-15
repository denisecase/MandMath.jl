"""
MandMath.jl is a Julia package for doing math with Mandelbrot sets.

# Example

```julia
julia> MandMath.greet()
"Hello MandMath!"
```

"""

module MandMath

using JSON
using HTTP
using Glob
using Pkg 
using Logging
using LoggingExtras # MultiLogger
using Base: PROGRAM_FILE # always available

include("functions.jl")


function logger_root_path()
  abspath(joinpath(dirname(PROGRAM_FILE), ".."))
end

function show_opening()
  logfile = joinpath(logger_root_path(), "log.txt")
  io = open(logfile, "a")
  file_logger = SimpleLogger(io)
  with_logger(file_logger) do
      console_logger = ConsoleLogger(stderr, LogLevel(Info))
      global_logger(file_logger)
      # add_logger(console_logger)
      @info file_logger "MandMath.jl loaded successfully."
  end
  global_logger(NullLogger())
  return file_logger
end

function show_closing()
  @info(file_logger, Logging.Info, "MandMath.jl completed successfully.")
end

function main(ARGS)
  # If no input file/url is provided, read from urls.txt and process all files
  if length(ARGS) == 0
    # Read URLs from urls.txt and process each one
    urls = readlines("urls.txt")
    for url in urls
      process_file_or_url(url)
    end
    # Process all .json files in local data directory recursively
    for file in Glob.glob("**/*.json")
      if occursin(".mandart", file)
          process_file_or_url(file)
      end
    end
  else
    # Process the specified file/url provided in the args
    input = ARGS[1]
    process_file_or_url(input)
  end
end

# execute some code if this file is run directly
if isfile(@__FILE__)
  show_opening()
  println(greet())
  # main(ARGS)
  show_closing()
end

end # end module
