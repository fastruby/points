FactoryBot.define do
  factory :estimate do
    transient do
      fibonacci_position { (0..(FIBONACCI_SEQUENCE.size - 2)).to_a.sample }
    end

    user
    story
    best_case_points { FIBONACCI_SEQUENCE[fibonacci_position] }
    worst_case_points { FIBONACCI_SEQUENCE[fibonacci_position + 1] }
  end
end
