require 'rails_helper'

RSpec.describe "estimates/new", type: :view do
  before(:each) do
    assign(:estimate, Estimate.new(
      :best_case_points => 1,
      :worst_case_points => 1,
      :user_id => 1,
      :story_id => 1
    ))
  end

  it "renders new estimate form" do
    render

    assert_select "form[action=?][method=?]", estimates_path, "post" do

      assert_select "input[name=?]", "estimate[best_case_points]"

      assert_select "input[name=?]", "estimate[worst_case_points]"

      assert_select "input[name=?]", "estimate[user_id]"

      assert_select "input[name=?]", "estimate[story_id]"
    end
  end
end
