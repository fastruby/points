FactoryBot.define do
  factory :project do
    title Faker::Lorem.word
    status "Active"
  end

end
