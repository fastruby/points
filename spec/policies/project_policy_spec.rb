require "rails_helper"

describe ProjectPolicy do
  subject { described_class }

  permissions :update? do
    let(:user) { FactoryBot.build(:user) }
    let(:locked_project) do
      FactoryBot.build(:project, locked: Time.current)
    end
    let(:project) do
      FactoryBot.build(:project, locked: nil)
    end

    it "denies access if project is locked" do
      expect(subject).not_to permit(user, locked_project)
    end

    it "grants access if project is not locked" do
      expect(subject).to permit(user, project)
    end
  end
end
