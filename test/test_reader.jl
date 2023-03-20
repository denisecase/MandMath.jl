using .Reader
using Test

@testset "Reader module tests" begin

    @testset "Reader.is_url function tests" begin
        @test Reader.is_url("http://example.com") == true
        @test Reader.is_url("https://example.com") == true
        @test Reader.is_url("ftp://example.com") == false
        @test Reader.is_url("file://example.com") == false
        @test Reader.is_url("example.com") == false
    end

    @testset "Reader.process_file function tests" begin
        @testset "invalid file extension" begin
            file_path = "test/data/test.txt"
            @test Reader.process_file(file_path) === nothing
        end
        @testset "invalid file path" begin
            file_path = "test/data/non_existent_file.mandart"
            @test Reader.process_file(file_path) === nothing
        end
        @testset "valid file path" begin
            file_path = "test/data/valid_data.mandart"
            @test Reader.process_file(file_path) === nothing
        end
        @testset "Reader.process_file" begin
            file_path = "data/denisecase/Opening.mandart"
            @test Reader.process_file(file_path) === nothing
        end
    end


    @testset "Reader.process_directory function tests" begin
        grid = Reader.process_directory()
        @test Reader.process_directory() === nothing
    end

    @testset "Reader.process_url function tests" begin
        @testset "invalid url" begin
            url = "ftp://example.com"
            @test Reader.process_url(url) === nothing
        end
        @testset "catch block cases" begin
            invalid_url = "https://invalid-url.example.com"
            @test_throws Exception Reader.process_url(invalid_url)
            invalid_json_url = "http://127.0.0.1:8080"
            @test_throws Exception Reader.process_url(invalid_json_url)
        end
    end

    @testset "Reader.read_urls_from_file no throw check" begin
        try
            Reader.read_urls_from_file()
            @test true
        catch ex
            @test false
        end
    end

end