FactoryBot.define do
  factory :project do
    title { Faker::Company.name }
  end
end
