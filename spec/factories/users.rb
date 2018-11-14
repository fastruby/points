FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "test#{n}@gmail.com" }
    password "123456"
    name "John"
    trait(:admin)  { admin  true }
  end
end
