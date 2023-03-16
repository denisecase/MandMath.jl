# Julia Code Notes


When src and data are same level under root:

`urls_file = joinpath(@__DIR__,"..","data", "urls.txt")`

In Julia, grid::Array{Float64,2} is a two-dimensional array of Float64 values, also known as a matrix.

On the other hand, a Vector{Float64} is a one-dimensional array of Float64 values, also known as a vector.

The main difference between a matrix and a vector is the number of dimensions they have. A matrix has two dimensions, corresponding to rows and columns, whereas a vector has only one dimension, corresponding to a single row or column.

Another important difference is the way indexing works. In a matrix, you need to specify both the row and column index to access a specific element. For example, to access the element in the second row and third column of grid, you would use grid[2, 3]. In a vector, you only need to specify the index of the element you want to access. For example, to access the third element of a vector v, you would use v[3].

In summary, the main differences between a Vector{Float64} and a Array{Float64,2} in Julia are their number of dimensions and the way indexing works.

