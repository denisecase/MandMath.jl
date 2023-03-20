# Julia Loading Packages

> import vs loading

In the Julia programming language, there are two ways to load a package: 
using and import. 
The primary difference between the two lies in how they 
handle the package's functions and types. 

Their differences:

1. `using`: When you load a package with `using`, it brings all exported functions and types from the package into your current namespace, allowing you to use them directly without any prefix. For example, if you use `using CSV`, you can simply call the `read` function as `CSV.read()` without needing to specify the package name as a prefix.

2. `import`: When you load a package with `import`, the package's functions and types are not directly added to your current namespace. To use a function or type from the package, you need to prefix it with the package name. For example, if you use `import CSV`, you have to call the `read` function as `CSV.read()`.

Sometimes using CSV for example, can to make it easier and more convenient to use the CSV package's functions without needing to add the package name as a prefix every time. 

I prefer to use import and to prefix the package name when calling its functions, like CSV.read(). This helps learn which methods are in each package.


## When Testing

You should use using Calculator when the file src/calculator.jl contains a module definition. This will make the functions and types defined in the module available in the current namespace, and allow you to call them directly without specifying the module name. For example, if you have a function foo defined in the Calculator module, you can call it like this:


using Calculator

foo(x)

On the other hand, you should use include("../src/calculator.jl") when you want to include a file that does not define a module, but instead contains standalone functions or other code that you want to use in your script or module. When you include a file using include, all the code in the file is executed in the current namespace, which means that any functions or variables defined in the file will be available in the current scope. For example, if you have a standalone function bar defined in src/calculator.jl, you can use it like this:


include("../src/calculator.jl")

bar(x)

In general, it is a good practice to define functionality in modules, especially if you plan to reuse the code in multiple projects. Modules allow you to organize your code into logical units and provide a clean and standardized interface for other code to use. On the other hand, including standalone files can be useful for quick prototyping or small scripts where you don't need the full organization and structure provided by modules.