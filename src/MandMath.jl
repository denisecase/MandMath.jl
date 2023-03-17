# SPDX-License-Identifier: MIT

"""
MandMath.jl is a Julia package for doing math related to Mandelbrot sets.

"""

module MandMath

import CSV
import Coverage
import DelimitedFiles
import Glob
import HTTP
import JSON
import Logging
import LoggingExtras
import Tables

include("constants.jl")
include("functions.jl")
include("grid.jl")

# Export functions and types visible outside the module

export greet
export get_grid
export get_grid_inputs
export GridInputs
export process_file_or_url
export main

end # end module
