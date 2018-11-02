FactoryBot.define do
  factory :estimate do
    user
    story
    best_case_points 1
    worst_case_points 3
  end
end
