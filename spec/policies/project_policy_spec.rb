require "rails_helper"

describe ProjectPolicy do
  subject { described_class }

  permissions :update? do
    let(:user) { FactoryBot.build(:user) }
    let(:locked_project) { FactoryBot.create(:project, locked_at: Time.current) }
    let(:project) { FactoryBot.create(:project, locked_at: nil) }

    context "when project doesn't belong to a parent project" do
      it "denies access if project is locked" do
        expect(subject).not_to permit(user, locked_project)
      end

      it "grants access if project is not locked" do
        expect(subject).to permit(user, project)
      end
    end

    context "when sub project belongs to a locked parent" do
      let(:sub_project) { FactoryBot.build_stubbed(:project, locked_at: nil, parent: locked_project) }

      it "denies access" do
        expect(subject).not_to permit(user, sub_project)
      end
    end

    context "when sub project belongs to an unlocked parent" do
      let(:sub_project) { FactoryBot.build_stubbed(:project, locked_at: nil) }

      it "grants access" do
        expect(subject).to permit(user, sub_project)
      end
    end
  end
end
