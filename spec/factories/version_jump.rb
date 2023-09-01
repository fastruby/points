FactoryBot.define do
  factory :version_jump do
    sequence(:technology) { |n| ["Rails", "Ruby", "Node", "React"].sample + n.to_s }
    initial_version { ["2.3", "3.0", "3.1", "3.2", "4.0", "4.1", "4.2"].sample }
    target_version { ["5.0", "5.1", "5.2", "6.0", "6.1", "7.0"].sample }
  end
end
