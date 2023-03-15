# Julia REPL

The Julia REPL (read-eval-print loop) is the interactive command-line interface for interacting with Julia. 

Type Julia code and see the output immediately. 
Define variables, functions, and modules, and run them in the REPL.

## Documentation

The full manual is available at

- <https://docs.julialang.org>

As well as many great tutorials and learning resources:

- <https://julialang.org/learning/>

For help on a specific function or macro, type ? followed by its name, e.g. ?cos, or ?@time, and press enter. 

## Modes

Type ; to enter shell mode.

Type ] to enter [package mode](Package-REPL.md).

## Exit Julia REPL

To exit the interactive session:

- hit `CTRL-D` (press the control key together with the d key), or 
- type `exit()`

## Execute Pkg Commands in the Julia REPL

Julia REPL examples.

```
versioninfo()

using Pkg
Pkg.upgrade_manifest()

# Get a unique ID

using UUIDs
uuid4()

# Load current package with:

using MandMath
using .

```

`Using MandMath` compiles the module and makes its exported functions and variables available in the current namespace.
