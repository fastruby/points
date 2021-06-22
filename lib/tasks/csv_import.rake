# run this like rails "csv_story_import[23,file.csv]"

task :csv_story_import, [:project_id, :file] => :environment do |task, args|
  require "csv"

  project = Project.find(args.project_id)
  puts "this will destroy any existing stories for the project '#{project.title}'. proceed? (Y/n)"
  response = $stdin.gets.chomp
  exit if /n/.match?(response.downcase)

  project.stories.destroy_all

  stories_csv = CSV.parse(File.read(args.file), headers: true)
  stories_csv.each do |story_csv|
    project.stories.create(title: story_csv["title"], description: story_csv["description"], position: story_csv["position"])
  end
  puts "project '#{project.title}' now has #{project.stories.count} stories"
end
