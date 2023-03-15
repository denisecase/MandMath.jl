"""
MandMath.jl is a Julia package for doing math with Mandelbrot sets.

# Example

```julia
julia> MandMath.greet()
"Hello MandMath!"
```

"""

module MandMath

include("functions.jl")

println()
println("==============================================")
println("MandMath.jl loaded successfully.")
println("==============================================")
println()
println(greet())
println("==============================================")
println("MandMath.jl completed successfully.")
println("==============================================")
println()

end # end module
