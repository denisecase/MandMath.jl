# MandMath

[![Build Status](https://github.com/denisecase/MandMath.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/denisecase/MandMath.jl/actions/workflows/CI.yml?query=branch%3Amaster)


## Background Documentation

- [Juila Installation on Windows](docs/Julia-Installation-Windows.md)
- [Julia in VS Code (using PowerShell)](docs/Julia-VSCode.md)
- [Juila REPL](docs/REPL.md)
- [Julia Package REPL](docs/Package-REPL.md)

## Activate Project Environment and Test

Open PowerShell in root project directory. 

```
julia
]
instantiate
activate .
test
```

Ctrl C to return to Julia REPL. Load our MandMath module and call a function. 

```
using MandMath
MandMath.greet()
```

CTRL D to exit back to PowerShell. 

## Adding a new Package (example)

Activate the environment, add the package to Project.toml, 
download, install, and build with `instantiate`.

```
] activate .
] add Combinatorics
] instantiate
] test
```

Or: in Julia:

```
import Pkg
Pkg.add("JSON")
Pkg.add("HTTP")
Pkg.add("Glob")
Pkg.add("Logging")
Pkg.add("LoggingExtras")
Pkg.precompile()
```

Using the ] key to activate the environment and add packages is a convenient way
 to manage dependencies within a specific environment. 
 It allows you to easily add, remove, and update packages as needed.

On the other hand, adding packages with the using command is useful when you 
want to make sure that specific packages are available in your code. 
This method can be especially helpful if you are sharing code with others, 
as it ensures that they have all the necessary dependencies installed.

## Manifest.toml

The Manifest.toml file in a Julia project is automatically generated and 
updated by the package manager when you activate the project environment and 
add or remove packages, update versions, or modify dependencies in your 
Project.toml file.

```
julia

] activate .
```

## Example Output

```
==============================================
MandMath.jl loaded successfully.
==============================================

Welcome to MandMath!
We'll use this to create a Julia executable.
We can use 150 decimal places for X and Y.

==============================================
MandMath.jl completed successfully.
==============================================

xCenter is -0.75
yCenter is 0.0
scale is 4.3e+02
c is -0.75 + 0.0im
xCenter is 1.2345678901234566904321354741114191710948944091796875
yCenter is 0.876543210987654308752325960085727274417877197265625
scale is 1.2e+08
c is 1.2345678901234566904321354741114191710948944091796875 + 0.876543210987654308752325960085727274417877197265625im
xCenter is 1.2345678901234566904321354741114191710948944091796875
yCenter is 0.876543210987654308752325960085727274417877197265625
scale is 1.2e+08
c is 1.2345678901234566904321354741114191710948944091796875 + 0.876543210987654308752325960085727274417877197265625im
Test Summary:  | Pass  Total  Time
MandMath Tests |    9      9  2.2s
     Testing MandMath tests passed
```

## MandArt

- [MandArt (App Store)](https://apps.apple.com/us/app/mandart/id6445924588?mt=12) - runs on MacOS (v12+) - _Released!_
- [MandArt-Docs](https://denisecase.github.io/MandArt-Docs/documentation/mandart/)
- [MandArt-Discoveries](https://github.com/denisecase/MandArt-Discoveries)

## MandArt Supporting

A SwiftUI app for creating custom art with the Mandelbrot set.

- [MandArt source repo](https://github.com/brucehjohnson/MandArt) 
- [MandArt-Docs source repo](https://github.com/denisecase/MandArt-Docs)
- [MandArt source repo - ARCHIVED](https://github.com/denisecase/MandArt) 

![MandArt](https://raw.githubusercontent.com/denisecase/MandArt-Discoveries/main/denisecase/Opening.png)


## Using Docker

Steps:

1. Build the Docker image.
2. Create an ECR repository for the lambda function.
3. Get the respositoryUri in the output.
4. Log in to the ECR repository.
5. Tag the Docker image and push it to the ECR repository.
6. Create the Lambda function using the custom runtime.

Open PowerShell in root project repo directory. 

```
docker build -t mandmath_lambda .

aws ecr create-repository --repository-name mandmath_lambda

aws ecr get-login-password --region <your_aws_region> | docker login --username AWS --password-stdin <your_account_id>.dkr.ecr.<your_aws_region>.amazonaws.com

docker tag mandmath_lambda:latest <your_account_id>.dkr.ecr.<your_aws_region>.amazonaws.com/mandmath_lambda:latest

docker push <your_account_id>.dkr.ecr.<your_aws_region>.amazonaws.com/mandmath_lambda:latest

aws lambda create-function \
    --function-name JuliaLambdaFunction \
    --package-type Image \
    --code ImageUri=<your_account_id>.dkr.ecr.<your_aws_region>.amazonaws.com/mandmath_lambda:latest \
    --role arn:aws:iam::<your_account_id>:role/lambda_basic_execution \
    --timeout 10 \
    --memory-size 1024 \
    --region <your_aws_region>


```