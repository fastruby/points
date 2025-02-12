#!/usr/bin/env ruby

# Get arguments passed to the container
commands = ARGV

def run_rubycritic
  system("rubycritic -p reports/rubycritic")
end

def run_skunk
  system("skunk -o reports/skunk.txt")
end

# Default behavior: Run both tools if no args are provided
if commands.empty?
  puts "No arguments provided. Running both RubyCritic and Skunk..."
  run_rubycritic
  exit 0
end

# Execute based on provided arguments
commands.each do |command|
  case command
  when "rubycritic"
    puts "Running RubyCritic..."
    run_rubycritic
  when "skunk"
    puts "Running Skunk..."
    run_skunk
  else
    puts "Invalid argument: #{command}"
    puts "Usage: docker run --rm <image> [rubycritic] [skunk]"
    exit 1
  end
end
