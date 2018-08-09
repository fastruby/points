require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { FactoryBot.create(:project) }

  it { should validate_presence_of(:title) }
  it { should have_many(:stories) }
end
