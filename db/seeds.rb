# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Project.find_or_create_by(title: "Test Project")

project_with_stories = Project.find_or_create_by(title: "Test Project With Stories")
3.times { |i| project_with_stories.stories.create(title: "Story ##{i}") } if project_with_stories.stories.count.zero?

project_with_estimates = Project.find_or_create_by(title: "Test Project With Estimates")
3.times { |i| project_with_estimates.stories.find_or_create_by(title: "Story ##{i}", description: "This is story ##{i}") }

first_user = User.find_or_create_by(email: "test1@ombulabs.com", name: "User 1") { |user|
  user.password = "123456"
}

second_user = User.find_or_create_by(email: "test2@ombulabs.com", name: "User 2") { |user|
  user.password = "123456"
}

project_with_estimates.stories.each { |story| story.estimates.find_or_create_by(user: first_user, best_case_points: 1, worst_case_points: 5) }
project_with_estimates.stories.each { |story| story.estimates.find_or_create_by(user: second_user, best_case_points: 1, worst_case_points: 5) }
