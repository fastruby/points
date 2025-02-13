#!/usr/bin/env ruby

require "bundler"

APP_ROOT = "/app/#{__dir__}"
REPORTS_DIR = File.join(APP_ROOT, "reports")

puts "Checking for rubycritic and skunk in the bundle..."

# Check if gems are installed
def gem_installed?(gem_name)
  Bundler.locked_gems.dependencies.key?(gem_name)
end

# Add missing gems and install
missing_gems = []
missing_gems << "rubycritic" unless gem_installed?("rubycritic")
missing_gems << "skunk" unless gem_installed?("skunk")

unless missing_gems.empty?
  puts "Adding missing gems: #{missing_gems.join(", ")}"
  bundle_add_command = "bundle add"
  missing_gems.each { |gem| bundle_add_command.concat(" #{gem}") }
  system(bundle_add_command)
  system("bundle install")
end

# Ensure the reports directory exists
# Dir.mkdir(REPORTS_DIR) unless Dir.exist?(REPORTS_DIR)
# File.chmod(0777, REPORTS_DIR)

puts "Running rubycritic and skunk, saving reports to #{REPORTS_DIR}..."

# Run rubycritic and skunk, directing output to the reports folder
system("bundle exec rubycritic -p #{REPORTS_DIR}/rubycritic")
system("bundle exec skunk -o #{REPORTS_DIR}/skunk-report.txt")

puts "Analysis complete. Check the reports folder for results."
