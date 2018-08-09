require 'rails_helper'

RSpec.describe Story, type: :model do
  subject { FactoryBot.create(:story) }

  it { should validate_presence_of(:title) }

  it { should belong_to(:project) }
end
