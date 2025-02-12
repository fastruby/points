#!/usr/bin/env ruby

# Get arguments passed to the container
commands = ARGV

# Default behavior: Run both tools if no args are provided
if commands.empty?
  puts "No arguments provided. Running both RubyCritic and Skunk..."
  system("rubycritic")
  system("skunk -o skunk.txt")
  exit 0
end

# Execute based on provided arguments
commands.each do |command|
  case command
  when "rubycritic"
    puts "Running RubyCritic..."
    system("rubycritic")
  when "skunk"
    puts "Running Skunk..."
    system("skunk -o skunk.txt")
  else
    puts "Invalid argument: #{command}"
    puts "Usage: docker run --rm <image> [rubycritic] [skunk]"
    exit 1
  end
end
