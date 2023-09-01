require "rails_helper"

RSpec.describe VersionJump, type: :model do
  subject { FactoryBot.create(:version_jump) }

  it "should be uniq by technology, initial version, and target version" do
    attrs = {
      technology: "Rails",
      initial_version: "4.2",
      target_version: "5.0"
    }

    jump1 = VersionJump.create(attrs)
    expect(jump1).to be_persisted

    jump2 = VersionJump.new(attrs)
    expect(jump2).to be_invalid
    expect(jump2.errors[:technology]).to be_present

    jump2.technology = "Ruby"
    expect(jump2).to be_valid

    jump2.technology = attrs[:technology]
    jump2.initial_version = "4.1"
    expect(jump2).to be_valid

    jump2.initial_version = attrs[:initial_version]
    jump2.target_version = "5.1"
    expect(jump2).to be_valid
  end
end
