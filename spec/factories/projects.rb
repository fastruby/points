FactoryBot.define do
  factory :project do
    title { Faker::Company.name }
    locked { nil }
  end
end
