# SPDX-License-Identifier: MIT

"""
MandMath.jl is a Julia package for doing math related to Mandelbrot sets.

"""

module MandMath

# first, import from external packages (in alphabetical order)

import Base: PROGRAM_FILE
import CSV
import Coverage
import DelimitedFiles
import HTTP
import JSON
import Glob
import Tables

# Include other files in the module
include("functions.jl")

# Export functions and types visible outside the module

export greet
export get_grid
export get_grid_inputs
export process_file_or_url
export GridInputs
export show_opening
export main

end # end module
