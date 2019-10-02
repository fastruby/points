# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
FactoryBot.create(:project)
project_with_stories = FactoryBot.create(:project)
3.times{|_| FactoryBot.create(:story, project: project_with_stories)}
first_user = FactoryBot.create(:user)
second_user = FactoryBot.create(:user)
project_with_estimates = FactoryBot.create(:project)
3.times{|_| FactoryBot.create(:story, project: project_with_estimates)}
project_with_estimates.stories.each{|story| FactoryBot.create(:estimate, story: story, user: first_user)}
project_with_estimates.stories.each{|story| FactoryBot.create(:estimate, story: story, user: second_user)}
