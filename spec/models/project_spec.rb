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

  describe ".sub_projects_with_approved_and_ordered_stories" do
    it "orders sub projects properly" do
      parent = FactoryBot.create(:project)
      sub_project1 = FactoryBot.create(:project, parent: parent, position: 2)
      story_5 = FactoryBot.create(:story, :approved, project: sub_project1, position: 2)
      story_4 = FactoryBot.create(:story, :approved, project: sub_project1, position: 1)
      story_6 = FactoryBot.create(:story, :approved, project: sub_project1, position: 3)

      sub_project2 = FactoryBot.create(:project, parent: parent, position: 1)
      story_3 = FactoryBot.create(:story, :approved, project: sub_project2, position: 3)
      story_1 = FactoryBot.create(:story, :approved, project: sub_project2, position: 1)
      story_2 = FactoryBot.create(:story, :approved, project: sub_project2, position: 2)
      sub_projects = Project.sub_projects_with_approved_and_ordered_stories(parent.id)

      expect(sub_projects.count).to eq 2
      expect(sub_projects[0].id).to eq sub_project2.id
      expect(sub_projects[0].stories[0].id).to eq story_1.id
      expect(sub_projects[0].stories[1].id).to eq story_2.id
      expect(sub_projects[0].stories[2].id).to eq story_3.id
      expect(sub_projects[1].id).to eq sub_project1.id
      expect(sub_projects[1].stories[0].id).to eq story_4.id
      expect(sub_projects[1].stories[1].id).to eq story_5.id
      expect(sub_projects[1].stories[2].id).to eq story_6.id
    end
  end

  describe "#archived?" do
    it "returns true if status is archived" do
      expect(Project.new(status: "archived")).to be_archived
    end

    it "returns false if status is not `archived`" do
      expect(Project.new(status: nil)).not_to be_archived
    end

    it "returns true if the parent is archived" do
      parent = FactoryBot.create(:project, status: "archived")
      sub_project1 = FactoryBot.create(:project, parent: parent)

      expect(sub_project1).to be_archived
    end

    it "returns false if the parent is not archived" do
      parent = FactoryBot.create(:project)
      sub_project1 = FactoryBot.create(:project, parent: parent)

      expect(sub_project1).not_to be_archived
    end
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

    it "won't update a sub project" do
      parent = FactoryBot.create(:project)
      sub_project1 = FactoryBot.create(:project, parent: parent)
      sub_project2 = FactoryBot.create(:project, parent: parent, status: "archived")

      expect(sub_project1).to_not be_archived
      expect(sub_project1.toggle_archived!).to eql(nil)
      sub_project1.reload
      expect(sub_project1).to_not be_archived

      expect(sub_project2).to_not be_archived
      expect(sub_project2.toggle_archived!).to eql(nil)
      sub_project2.reload
      expect(sub_project2).to_not be_archived
    end
  end

  describe "#cloning behaviour" do
    it "clones stories into the new project but does not copy status" do
      original_project = FactoryBot.create(:project)
      FactoryBot.create(:story, :approved, project: original_project, position: 2)
      FactoryBot.create(:story, :rejected, project: original_project, position: 1)
      FactoryBot.create(:story, :pending, project: original_project, position: 3)

      new_project = FactoryBot.create(:project)
      original_project.clone_stories_into(new_project)
      new_project.stories.each do |story|
        expect(story).to be_pending
      end
    end
  end

  def add_sub_project
    FactoryBot.create(:project, parent: subject, status: subject.status)
  end
end
