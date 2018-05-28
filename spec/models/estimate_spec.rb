require "rails_helper"

RSpec.describe Estimate, type: :model do
  subject { FactoryBot.create(:estimate) }

  it { should belong_to(:user) }
  it { should belong_to(:story) }
end
