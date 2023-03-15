# Julia Package REPL

The Julia package REPL is a separate REPL launched when you activate a package environment using the ] activate command. 

It's a specialized REPL designed to work with the dependencies and modules of the activated package environment.

Use the package REPL to install, update, and remove packages, and run tests and benchmarks for the packages in the environment.

The package REPL is useful when you are working on a project with its own set of dependencies and modules, and you want to manage those separately from the global environment. This helps avoid conflicts between package versions and allows work on multiple projects using different dependencies simultaneously.

## Open The Package REPL

Open PowerShell, type `julia` to get the Julia REPL. 

To enter the Package REPL, hit ].

## Close the Package REPL

To return to the julia> prompt, either press 

- backspace when the input line is empty or press 
- Ctrl+C

## Documentation

Full documentation available at <https://pkgdocs.julialang.org/>.

## Synopsis

`pkg> cmd [opts] [args]`

Multiple commands can be given on the same line by interleaving a ; between the commands. 

Some commands have an alias, indicated below.

## Commands

- **activate**: set the primary environment the package manager manipulates

- **add**: add packages to project

- build: run the build script for packages

- compat: edit compat entries in the current Project and re-resolve

- develop, dev: clone the full package repo locally for development

- free: undoes a pin, develop, or stops tracking a repo

- gc: garbage collect packages not used for a significant time

- generate: generate files for a new project

- help, ?: show this message

- **instantiate**: download and install all packages listed in `Project.toml` for current environment

- pin: pins the version of packages

- precompile: precompile all the project dependencies

- redo: redo the latest change to the active project

- remove, rm: remove packages from project or manifest

- resolve: resolves to update the manifest from changes in dependencies of developed packages

- status, st: summarize contents of and changes to environment

- test: run tests for packages

- undo: undo the latest change to the active project

- **update**, up: update packages in manifest

- registry add: add package registries

- registry remove, rm: remove package registries

- registry status, st: information about installed registries

- registry update, up: update package registries
