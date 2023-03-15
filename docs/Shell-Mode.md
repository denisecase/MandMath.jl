# Julia Shell Mode

Julia shell mode is a command-line interface for running Julia code without launching the full [Julia REPL](REPL.md). 

It allows you to quickly execute Julia commands and scripts from your operating system's shell prompt, just like you would with any other shell command.

## To Enter Shell Mode

Open PowerShell (or other terminal) and enter `julia` followed by the Julia code you want to run at the command prompt, like this:

```Julia
julia -e 'println("Hello, world!")'
julia -e 'println(2 + 2)'

```

This command runs the `julia` command with the `-e` (evaluate) option, 
which means the following string is a single line of Julia code to be executed. 

In this case, the code simply prints the message or result to the console.

## Run Scripts

You can use shell mode to run entire Julia scripts, like this:

```julia
julia myscript.jl
```

## Commands

Julia shell mode is essentially the same as the Julia REPL, 
with the exception that you're running it from your operating system's shell prompt instead of launching it directly from the terminal. 

All commands and syntax available in the Julia REPL are available in Julia shell mode.

Some basic commands avaiable in Julia shell mode:

- ? - Displays help for the current context.
- ; - Enters shell mode, allowing you to execute shell commands.
- ] - Enters package mode, allowing you to manage Julia packages.
- using - Loads a Julia module or package.
- include - Executes a Julia script file.
- Ctrl-D - return to the operating system shell.
- exit() - return to the operating system shell.

Use all Julia syntax features and constructs available in a Julia script or REPL session, including variable assignments, functions, loops, conditionals, etc.