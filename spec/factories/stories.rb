FactoryBot.define do
  factory :story do
    title { Faker::ChuckNorris.fact }
    description { Faker::Marketing.buzzwords }
    project
  end
end
