# SPDX-License-Identifier: MIT
#=

Reader module

This is used to read .mandart data files for calculation.

    Examples

    ```julia
    julia> using MandArt
    julia> Reader.read_urls_from_file()
    ```

Auhor:  Denise M Case
Date:   2023-03-18

=#

module Reader

using DelimitedFiles
using Glob
using HTTP
using JSON
using Logging
using Printf
using Tables

include("./calculator.jl")

export is_url
export process_file
export process_directory
export process_url
export read_urls_from_file

const DATA_FOLDER = "data"
const DATA_URL_FILE = "urls.txt"
const DATA_FILE_EXTENTION = ".mandart"

function is_url(input)
    return occursin("http://", input) || occursin("https://", input) ? true : false
end

function process_file(file_path)
    @info "Reader.process_file called with $file_path"
    if isfile(file_path)
        if occursin(DATA_FILE_EXTENTION, file_path)
            data = JSON.parsefile(file_path)
            Calculator.process_data_for_file(data, file_path)
        end
    end
end

function process_directory()
    @info "Reader.process_directory called"
    data_dir = joinpath(@__DIR__, "..", DATA_FOLDER)
    data_dir_path = joinpath(data_dir, DATA_URL_FILE)
    if isdir(data_dir_path)
        @info "process_directory DIR:  $data_dir_path"
        for file in Glob.glob(joinpath(data_dir_path, "**/*.mandart"))
            Reader.process_file(file)
        end
    end
end

function process_url(url::String)
    @info "Reader.process_url called with $url"
    if Reader.is_url(url)
        response = HTTP.get(url)
        @info "Response: $response"
        try
            data = JSON.parse(String(response.body))
            @info "data: $data"
            Calculator.process_data_for_url(data, url)
        catch
            @error "Failed to process url: $url"
        end
    end
end


function read_urls_from_file()
    @info "Reader.read_urls_from_file called"
    @info "Reading from $Reader.DATA_FOLDER."
    @info "Reading from $Reader.DATA_URL_FILE."
    url_fp = joinpath(@__DIR__, "..", Reader.DATA_FOLDER, Reader.DATA_URL_FILE)
    if isfile(url_fp)
        urls = readlines(url_fp)
        for url in urls
            Reader.process_url(url)
        end
    else
        @error "File not found: $url_fp"
    end
end

end