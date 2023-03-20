# SPDX-License-Identifier: MIT
#=

Writer module

This is used to write results to a file.

    Examples

    ```julia
    julia> using MandArt
    julia> Writer.write_grid_to_csv()
    ```

Auhor:  Denise M Case
Date:   2023-03-18

=#
module Writer

using CSV
using HTTP
using Tables
using URIs

export write_grid_to_csv

const OUTPUT_FOLDER = "output"
const OUT_FILE_EXT = ".csv"

function get_base_name_from_file_path(filename::String, ext::String)
    base_name_without_ext = splitext(filename)[1]
    output_file_basename = joinpath(base_name_without_ext * ext)
    return output_file_basename
end

function get_base_name_from_url(url::String, ext::String)
    url_parts = URIs.URI(url)
    path = url_parts.path
    base_filename = basename(path)
    base_name_without_ext = splitext(base_filename)[1]
    output_file_basename = joinpath(base_name_without_ext * ext)
    return output_file_basename
end

function write_grid_to_csv(grid::Array{Float64,2}, input_file_path::String,)
    output_dir = joinpath(@__DIR__, "..", OUTPUT_FOLDER)
    if !isdir(output_dir)
        Base.mkdir(output_dir)
    end
    is_url = occursin(r"^https?://", input_file_path)
    output_file_basename = if is_url
        get_base_name_from_url(input_file_path,OUT_FILE_EXT)
    else
        get_base_name_from_file_path(input_file_path, OUT_FILE_EXT)
    end
    output_file_path = joinpath(output_dir, output_file_basename)
    table = Tables.table(grid)
    CSV.write(output_file_path, table, header=false)
end

end