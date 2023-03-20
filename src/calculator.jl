# SPDX-License-Identifier: MIT
#=

=#
module Calculator

using CSV
using DelimitedFiles
using Glob
using Logging
using Printf
using Tables

include("./writer.jl")

export get_grid
export get_grid_inputs
export process_data_for_file
export process_data_for_url
export GridInputs

const IMAGE_WIDTH_DEFAULT = 1200
const IMAGE_HEIGHT_DEFAULT = 1000
const X_CENTER_DEFAULT = BigFloat(-0.75)
const Y_CENTER_DEFAULT = BigFloat(0.0)
const SCALE_DEFAULT = BigFloat(430.0)
const ITERATIONS_MAX_DEFAULT = 10000.0
const R_SQ_LIMIT_DEFAULT = 400.0
const DF_ITER_MIN_DEFAULT = 0.0
const THETA_DEFAULT = 0.0
const YY_DEFAULT = 0.0

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

    # Constructor requires all keyword arguments or none GridInputs()
    function GridInputs(; imageWidth::Int=IMAGE_WIDTH_DEFAULT,
        imageHeight::Int=IMAGE_HEIGHT_DEFAULT,
        xCenter::Union{BigFloat,Float64}=X_CENTER_DEFAULT,
        yCenter::Union{BigFloat,Float64}=Y_CENTER_DEFAULT,
        scale::BigFloat=SCALE_DEFAULT,
        iterationsMax::Float64=ITERATIONS_MAX_DEFAULT,
        rSqLimit::Float64=R_SQ_LIMIT_DEFAULT,
        dFIterMin::Float64=DF_ITER_MIN_DEFAULT,
        theta::Float64=THETA_DEFAULT,
        yY::Float64=YY_DEFAULT)
        new(imageWidth, imageHeight, xCenter,
            yCenter, scale, iterationsMax, rSqLimit,
            dFIterMin, theta, yY)
    end
end

function process_data_for_file(data::Dict, fp::String)
    @info "Calculator.process_data_for_file called on $fp"
    inputs = Calculator.get_grid_inputs(data)
    grid = Calculator.get_grid(inputs)
    Writer.write_grid_to_csv(grid, fp)
end

function process_data_for_url(data::Dict, url::String)
    @info "Calculator.process_data_for_url called on $url"
    inputs = Calculator.get_grid_inputs(data)
    grid = Calculator.get_grid(inputs)
    Writer.write_grid_to_csv(grid, url)
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

function get_grid(inputs::GridInputs)
    @info "Calculator.get_grid() called with inputs: $inputs."

    w, h = inputs.imageWidth, inputs.imageHeight
    xCenter, yCenter, scale = inputs.xCenter, inputs.yCenter, inputs.scale

    wmin, wmax = 4, 10000
    hmin, hmax = 4, 10000
    xmin, xmax = -2.0, 2.0
    ymin, ymax = -2.0, 2.0
    scalemin, scalemax = 1.0, 1.0e100

    if w < wmin || w > wmax
        @error("image width, w, must be between $wmin and $wmax pixels.")
    end
    if h < hmin || h > hmax
        @error("image height, h, must be between $hmin and $hmax pixels.")
    end
    if xCenter < xmin || xCenter > xmax
        @error("Starting X must be between $xmin and $xmax.")
    end
    if yCenter < ymin || yCenter > ymax
        @error("Starting Y must be between $ymin and $ymax.")
    end
    if scale < scalemin || scale > scalemax
        @error("Scale must be between $scalemin and $scalemax.")
    end

    grid = Array{Float64}(undef, w, h)
    easy = false
    if easy
        @info "Calculator.get_grid() filling grid - easy mode."
        for i in 1:w, j in 1:h
            grid[i, j] = 1.24 + rand() * (567.83 - 1.24)
        end
        @info "Calculator.get_grid() finished filling grid. Returning grid."
        return grid
    else
        @info "Calculator.get_grid() filling grid - reuglar mode."

        # replicate mandart
        thetaR = pi * inputs.theta / 180.0 # R for Radians
        rSq = 0.0
        rSqMax = 0.0
        x0 = 0.0
        y0 = 0.0
        dX = 0.0
        dY = 0.0
        xx = 0.0
        yy = 0.0
        xTemp = 0.0
        iter = 0.0
        dIter = 0.0
        gGML = 0.0
        gGL = 0.0

        fIter = zeros(Float64, (inputs.imageWidth, inputs.imageHeight))
        @info "fIter.shape: $(size(fIter))"
        fIterMinLeft = 0.0
        fIterMinRight = 0.0
        fIterBottom = zeros(Float64, inputs.imageWidth)
        fIterTop = zeros(Float64, inputs.imageHeight)
        fIterMinBottom = 0.0
        fIterMinTop = 0.0
        fIterMins = zeros(Float64, 4)
        fIterMin = 0.0
        p = 0.0
        test1 = 0.0
        test2 = 0.0
        rSqMax = 1.01 * (inputs.rSqLimit + 2) * (inputs.rSqLimit + 2)
        gGML = log(log(rSqMax)) - log(log(inputs.rSqLimit))
        gGL = log(log(inputs.rSqLimit))

        # Julia is 1-based
        for u in 1:(inputs.imageWidth)
            for v in 1:(inputs.imageHeight)

                dX = (Float64(u) - Float64(inputs.imageWidth) / 2.0) / scale
                dY = (Float64(v) - Float64(inputs.imageHeight) / 2.0) / scale

                x0 = xCenter + dX * cos(thetaR) - dY * sin(thetaR)
                y0 = yCenter + dX * sin(thetaR) + dY * cos(thetaR)

                xx = x0
                yy = y0
                rSq = xx * xx + yy * yy
                iter = 0.0

                p = sqrt((xx - 0.25) * (xx - 0.25) + yy * yy)
                test1 = p - 2.0 * p * p + 0.25
                test2 = (xx + 1.0) * (xx + 1.0) + yy * yy

                if xx < test1 || test2 < 0.0625
                    fIter[u, v] = inputs.iterationsMax # black
                    iter = inputs.iterationsMax # black
                end
                @info "u: $u, v: $v, rSq: $rSq, log(rSq): $(log(rSq))"
                # The logarithm of a negative number or zero is undefined 
                # in the realm of real numbers and results in a complex number 
                # in the realm of complex numbers.
                # Ensure that the argument passed to the log function is 
                # strictly positive.
                if iter < inputs.iterationsMax
                    if (log(rSq)) <= 0 
                        @error "log(rSq) is <= 0 - can't take the log again."
                        exit(1)
                    end
                    dIter = Float64(-(log(log(rSq)) - gGL) / gGML)

                    fIter[u, v] = iter + dIter

                else
                    fIter[u, v] = iter
                end

            end # end first for v
        end # end first for u

        #fIterGlobal = fIter

        for u in 1:(inputs.imageWidth)
            fIterBottom[u] = fIter[u, 1]
            fIterTop[u] = fIter[u, inputs.imageHeight]
        end #second for u

        #fIterMinLeft = fIter[0].min()!
        fIterMinLeft = minimum(fIter[1, :]; emptycheck=true)

        #fIterMinRight = fIter[inputs.imageWidth - 1].min()! 
        fIterMinRight = minimum(fIter[inputs.imageWidth, :]; emptycheck=true)

        #fIterMinBottom = fIterBottom.min()!
        fIterMinBottom = minimum(fIterBottom; emptycheck=true)

        #fIterMinTop = fIterTop.min()!
        fIterMinTop = minimum(fIter[:, 1]; emptycheck=true)

        fIterMins = [fIterMinLeft, fIterMinRight, fIterMinBottom, fIterMinTop]

        #fIterMin = fIterMins.min()!
        fIterMin = minimum(fIterMins; emptycheck=true)

        fIterMin = fIterMin - dFIterMin

        @info "Calculator.get_grid() finished filling grid fIter. Returning fIter."
        return fIter
    end # not easy

end

end

