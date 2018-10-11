require 'rails_helper'

RSpec.describe 'managing projects' do
  before do
    user = FactoryBot.create(:user)
    login_as(user, :scope => :user)
  end

  it "allows me to log in" do
    visit root_path
    expect(page).to have_content "Log out"
  end

  expect(Project.count).to eq 1

end
