# Start from the official Julia image
# https://github.com/docker-library/julia
FROM julialang/julia:1.9-rc

# Set the working directory
# This will be created in the container
WORKDIR /app

# Install the required packages
RUN julia -e 'using Pkg; Pkg.add(["AWSCore", "HTTP"])'

# Copy the handler function from src/ to /app
COPY src/handler.jl /app

# Set the entrypoint for the container
CMD ["julia", "/app/handler.jl"]
