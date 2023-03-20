"""

Before running, en sure that the MandMath package is installed and 
activated in the environment where you are running this script. 
You can do this by running the following commands in the Julia REPL:


using Pkg
Pkg.activate(".")

or 

] activate .
] instantiate
] build
] test

"""


using Pkg
using Logging

log_dir = joinpath(@__DIR__, "logs")
if isdir(log_dir)
    rm(log_dir; recursive=true)
    @info "Deleted logs folder at $log_dir"
end

src_dir = joinpath(@__DIR__, "src")
cov_files = filter(x -> occursin(r"\.cov$", x), readdir(src_dir))
for file in cov_files
    rm(joinpath(src_dir, file))
    @info "Deleted coverage file $file from $src_dir"
end

Pkg.build("MandMath")

# Start with a clean cache
#Pkg.precompile()

# Activate the package and instantiate its dependencies
Pkg.activate(".")
Pkg.instantiate()

# Check for dependency issues
function check_dependency_issues()
    has_issues = false
    installed_packages = Pkg.dependencies()
    project_dependencies = Dict(dep.first => dep.second for dep in Pkg.dependencies())
    std_pkgs = ["Base", "Core", "InteractiveUtils", "Logging", "REPL", "Test"]
    shipped_pkgs = keys(Pkg.installed())
    for (pkg_name, pkg_uuid) in project_dependencies
        if pkg_uuid in keys(installed_packages)
            installed_pkg = installed_packages[pkg_uuid]
            required_version = installed_pkg.version
            if pkg_name ∉ std_pkgs && pkg_name ∉ shipped_pkgs
                @warn "Unknown package $pkg_name. Assuming there might be a dependency issue."
                has_issues = true
            elseif pkg_name ∉ std_pkgs && installed_pkg.version < required_version
                @warn "Dependency issue detected: Package $pkg_name, Installed version: $(installed_pkg.version), Required version: $required_version"
                has_issues = true
            end
        else
            #@warn "Package $pkg_name not found. Assuming there might be a dependency issue."
            #has_issues = true
        end
    end
    return has_issues
end

test = false

if test

    Pkg.test("MandMath", coverage=true)

    using Coverage
    coverage = Coverage.process_folder()
    coverage_folder = joinpath(@__DIR__, "coverage")
    mkpath(coverage_folder) # This creates the folder if it does not exist
    covered_lines, total_lines = get_summary(coverage)
    lcov_file_path = joinpath(coverage_folder, "coverage.lcov")
    Coverage.LCOV.writefile(lcov_file_path, coverage)

    # You can also submit the coverage report to a service like Codecov, if desired
    # using Codecov
    # Codecov.submit_local("coverage.lcov")

end

using MandMath
App.run()

