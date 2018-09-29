FactoryBot.define do
  factory :story do
    title { Faker::Lorem.words(3) }
    project
  end
end
