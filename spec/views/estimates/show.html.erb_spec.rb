require 'rails_helper'

RSpec.describe "estimates/show", type: :view do
  before(:each) do
    @estimate = assign(:estimate, Estimate.create!(
      :best_case_points => 2,
      :worst_case_points => 3,
      :user_id => 4,
      :story_id => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
  end
end
