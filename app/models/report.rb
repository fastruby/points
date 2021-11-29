require "csv"

class Report
  MINIMUM_ESTIMATES_PER_STORY = 2

  attr_reader :project

  def initialize(project)
    @project = project
  end

  def stories
    project.stories.by_position
  end

  def to_csv
    CSV.generate(headers: ["Story", "Best Estimate Average", "Worst Estimate Average"], write_headers: true) do |csv|
      stories.each do |story|
        csv << [story.title, story.best_estimate_average, story.worst_estimate_average]
      end
    end
  end
end
