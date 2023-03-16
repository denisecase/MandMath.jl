# Pkg

In julia>

In Julia, the Pkg package provides several useful commands for managing packages. Here are some helpful commands:

Pkg.add(pkg_name): Adds a package to the current project. Replace pkg_name with the name of the package you want to install.

Pkg.update(): Updates all packages in the current project to their latest compatible versions.

Pkg.rm(pkg_name): Removes a package from the current project. Replace pkg_name with the name of the package you want to remove.

Pkg.status(): Displays the status of all packages in the current project, including their versions and possible updates.

Pkg.test(pkg_name): Runs the test suite for a specific package. Replace pkg_name with the name of the package you want to test.

Pkg.activate(path): Activates the project or environment at the given path. If no path is provided, it activates the default environment.

Pkg.deactivate(): Deactivates the current active project or environment and returns to the default environment.

Pkg.instantiate(): Ensures that all the dependencies of the current project or environment are installed and at the correct versions, as specified in the Manifest.toml file.

Pkg.gc(): Cleans up unused package versions and removes packages that are no longer required, freeing up disk space.

Pkg.Registry.add(url): Adds a new package registry by providing the registry's URL. Useful for adding custom or private registries.

Pkg.Registry.rm(registry_name): Removes a package registry. Replace registry_name with the name of the registry you want to remove.

Pkg.Registry.update(): Updates package registries to their latest versions.

Official Julia Pkg documentation:

- <https://pkgdocs.julialang.org/v1/>