require 'rails_helper'

RSpec.describe 'managing reports' do

  let!(:user) {FactoryBot.create(:user, :admin, name: "John")}
  let!(:project) {FactoryBot.create(:project)}
  let!(:story) {FactoryBot.create(:story, project: project)}

  before do
    login_as(user, :scope => :user)
  end

  context "with no estimates" do

    it "shows no estimates" do
      visit project_report_path(project.id)
      expect(page).to have_content "Not enough estimates"
    end
  end

  context "with one estimate" do
    let!(:estimate) {FactoryBot.create(:estimate, story: story, user: user)}

    it "allows me see a report with a project title, list of stories and estimates" do
      visit project_report_path(project.id)
      expect(page).to have_content project.title
      expect(page).to have_content story.title
      expect(page).to have_content "#{user.name}'s Best Estimate"
      expect(page).to have_content "#{user.name}'s Worst Estimate"
    end

    it "does not calculate averages" do
      visit project_report_path(project.id)
      expect(page).to have_content "Not enough estimates"
    end
  end

  context "with more than one estimate" do
    let!(:user_2) {FactoryBot.create(:user, name: "Sarah")}
    let!(:estimate) {FactoryBot.create(:estimate, story: story, user: user)}
    let!(:estimate_2) {FactoryBot.create(:estimate, story: story, user: user_2)}
    let!(:best_estimate_average) {1}
    let!(:worst_estimate_average) {3}
    let!(:best_estimate_sum) {1}
    let!(:worst_estimate_sum) {3}

    it "calculates averages" do
      visit project_report_path(project.id)
      expect(page).to have_content best_estimate_average
      expect(page).to have_content worst_estimate_average
      within('td#best') do
        expect(page).to have_content best_estimate_sum
      end
      within('td#worst') do
        expect(page).to have_content worst_estimate_sum
      end
    end
  end

end
