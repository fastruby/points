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

  describe "#toggle_archived!" do
    context "when unarchived" do
      before(:each) do
        subject.update_column :status, nil
      end

      it "archives the project" do
        subject.toggle_archived!
        expect(subject.reload).to be_archived
      end

      it "archives sub projects" do
        add_sub_project

        subject.toggle_archived!

        expect(subject.projects).to_not be_empty
        subject.projects.each do |project|
          expect(project).to be_archived
        end
      end
    end

    context "when archived" do
      before(:each) do
        subject.update_column :status, "archived"
      end

      it "unarchives the project" do
        subject.toggle_archived!
        expect(subject.reload).to_not be_archived
      end

      it "unarchives sub projects" do
        add_sub_project

        subject.toggle_archived!

        expect(subject.projects).to_not be_empty
        subject.projects.each do |project|
          expect(project).to_not be_archived
        end
      end
    end
  end

  def add_sub_project
    FactoryBot.create(:project, parent: subject, status: subject.status)
  end
end
