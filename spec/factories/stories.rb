FactoryBot.define do
  factory :story do
    title { Faker::ChuckNorris.fact }
    description { Faker::Marketing.buzzwords }
    title { "This is a tester story" }
    description { "This is the description" }
    real_score { 2 }
    project
  end
end
