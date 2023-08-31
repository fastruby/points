FactoryBot.define do
  factory :project do
    title { Faker::Company.name }
    version_jump
    trait :locked do
      locked_at { Time.current }
    end
    trait :archived do
      status { "archived" }
    end
  end
end
