FactoryBot.define do
  factory :project do
    title { Faker::Company.name }
    locked_at { nil }
  end
end
