using Pkg

log_dir = joinpath(@__DIR__,  "logs")
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

# Start with a clean cache
Pkg.precompile()

# Activate the package and instantiate its dependencies
Pkg.activate(".")
Pkg.instantiate()

# Run tests with coverage enabled
Pkg.test("MandMath", coverage=true)

# Process coverage information
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

using MandMath
MandMath.main()