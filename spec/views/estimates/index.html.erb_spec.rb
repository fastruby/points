require 'rails_helper'

RSpec.describe "estimates/index", type: :view do
  before(:each) do
    assign(:estimates, [
      Estimate.create!(
        :best_case_points => 2,
        :worst_case_points => 3,
        :user_id => 4,
        :story_id => 5
      ),
      Estimate.create!(
        :best_case_points => 2,
        :worst_case_points => 3,
        :user_id => 4,
        :story_id => 5
      )
    ])
  end

  it "renders a list of estimates" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
