# SPDX-License-Identifier: MIT

module MandMath

include("app.jl")
include("calculator.jl")
include("reader.jl")
include("writer.jl")

export run

# reader

export is_url
export process_file
export process_directory
export process_url
export read_urls_from_file

# calculator

export get_grid
export get_grid_inputs
export process_data_for_file
export process_data_for_url
export GridInputs

# writer

export write_grid_to_csv

end
