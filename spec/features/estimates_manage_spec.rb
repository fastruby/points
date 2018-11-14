require 'rails_helper'

RSpec.describe 'managing estimates' do

  let(:user) {FactoryBot.create(:user)}
  let(:project) {FactoryBot.create(:project)}
  let!(:story) {FactoryBot.create(:story, project: project)}

  before do
    login_as(user, :scope => :user)
  end

  context "with one unestimated story" do
    it "allows me to add an estimate" do
      visit project_path(id: project.id)
      click_link 'Add Estimate'
      fill_in 'estimate[best_case_points]', with: "3"
      fill_in 'estimate[worst_case_points]', with: "8"
      click_button 'Create'
      expect(Estimate.count).to eq 1
      expect(page).to have_content "Estimate created!"
    end
  end

  context "with one estimated story" do
    let!(:estimate) {FactoryBot.create(:estimate, story: story, user: user)}

    it "allows me to edit an estimate" do
      visit project_path(id: project.id)
      click_link 'Edit Estimate'
      fill_in 'estimate[best_case_points]', with: "1"
      fill_in 'estimate[worst_case_points]', with: "2"
      click_button 'Save Changes'
      expect(page).to have_content "Estimate updated!"
    end
  end
end
