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