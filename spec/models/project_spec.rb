require "rails_helper"

RSpec.describe Project, type: :model do
  subject { FactoryBot.create(:project) }

  it { should have_many(:projects).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should have_many(:stories) }
  it { should belong_to(:parent) }

  it "does not set a position if not a sub project" do
    parent = FactoryBot.create(:project)
    expect(parent.position).to be_nil
  end

  it "sets a position scoped within a parent" do
    parent = FactoryBot.create(:project)
    sub_project1 = FactoryBot.create(:project, parent: parent)
    sub_project2 = FactoryBot.create(:project, parent: parent)
    expect(sub_project1.position).to eq 1
    expect(sub_project2.position).to eq 2
  end
end
