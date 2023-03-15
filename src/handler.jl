using AWSCore
using HTTP

function handler(event)
    # Replace this with your desired Julia function
    return "Hello from Julia Lambda Function!"
end

function main()
    event = Dict()
    result = handler(event)
    println(result)
end

main()
