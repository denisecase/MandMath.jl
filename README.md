# MandMath

[![Build Status](https://github.com/denisecase/MandMath.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/denisecase/MandMath.jl/actions/workflows/CI.yml?query=branch%3Amaster)


## Julia in VS Code

Add Julia extension. When prompted, set setting.julia.executablePath to:

`C:\\Users\\deniselive\\AppData\\Local\\Programs\\Julia-1.8.5\\bin\\julia.exe`

## Activate Project Environment, Compile, and Test

Open PowerShell in root project directory. 

```
julia
]
activate .
instantiate
test
```

Hit backspace or Ctrl C to return to Julia REPL. 

Load our MandMath module and call the main() function. 

Note: This does not update any changes to the code. 

```
using MandMath
MandMath.main()
```

CTRL D to exit back to PowerShell. 

## Test Coverage

`] Add Coverage`

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
Pkg.precompile()
using MandMath
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

## Notes On Julia

- See docs folder.

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
