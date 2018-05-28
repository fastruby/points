FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "123456" }
    name { Faker::Name.name }
    trait(:admin) do
      admin { true }
    end
  end
end
