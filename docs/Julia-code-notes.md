# Julia Code Notes


When src and data are same level under root:

`urls_file = joinpath(@__DIR__,"..",DATA_FOLDER, DATA_URL_FILE)`


## Decimal Places

Julia's default Float64 type has about 15-16 decimal digits of precision. 
This is due to the fact that Float64 uses 64 bits to represent a 
floating-point number, with 1 bit for the sign, 11 bits for the exponent, 
and 52 bits for the significand (also called the mantissa or fraction).

In practice, the number of decimal places that can be accurately represented 
by a Float64 number depends on a variety of factors, including the magnitude 
of the number, the specific arithmetic operations being performed, and the 
rounding modes used. In some cases, operations on Float64 values can result 
in loss of precision or rounding errors, which can affect the number of 
decimal places that are accurate.

If you need higher precision than Float64 can provide, Julia also supports 
arbitrary-precision arithmetic through the BigFloat type, which can represent 
floating-point numbers with a user-defined number of digits. However, BigFloat 
calculations can be **significantly slower** than Float64 calculations, 
so they should be used with caution when performance is a concern.

## Arrays and Vectors

In Julia, grid::Array{Float64,2} is a two-dimensional array of Float64 values, 
also known as a matrix.

On the other hand, a Vector{Float64} is a one-dimensional array of Float64 
values, also known as a vector.

The main difference between a matrix and a vector is the number of dimensions 
they have. A matrix has two dimensions, corresponding to rows and columns, 
whereas a vector has only one dimension, corresponding to a single row or column.

Another important difference is the way indexing works. In a matrix, you 
need to specify both the row and column index to access a specific element. 
For example, to access the element in the second row and third column of grid, 
you would use grid[2, 3]. In a vector, you only need to specify the index of 
the element you want to access. For example, to access the third element of 
a vector v, you would use v[3].

In summary, the main differences between a Vector{Float64} and a 
Array{Float64,2} in Julia are their number of dimensions and the way 
indexing works.

