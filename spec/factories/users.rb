FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "test#{n}@gmail.com" } 
    password "123456"
  end
end
