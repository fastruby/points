require "rails_helper"

RSpec.describe Comment, type: :model do
  subject { FactoryBot.create(:comment) }

  it { should belong_to(:user) }
  it { should belong_to(:story) }
  it { should validate_presence_of(:body) }
end
