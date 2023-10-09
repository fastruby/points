FactoryBot.define do
  factory :comment do
    body { Faker::ChuckNorris.fact }
    user
    story
  end
end
