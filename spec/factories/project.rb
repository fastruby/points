FactoryBot.define do
  factory :project, class: Project do
    title Faker::Lorem.word
    status "Active"
  end

end
