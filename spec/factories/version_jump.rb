FactoryBot.define do
  factory :version_jump do
    technology { ["Rails", "Ruby", "Node", "React"].sample }
    initial_version { ["2.3", "3.0", "3.1", "3.2"].sample }
    target_version { ["5.0", "5.1", "5.2", "6.0"].sample }
  end
end
