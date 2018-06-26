require 'rails_helper'

RSpec.describe "stories/index", type: :view do
  before(:each) do
    assign(:stories, [
      Story.create!(
        :title => "Title",
        :description => "MyText",
        :project_id => 2
      ),
      Story.create!(
        :title => "Title",
        :description => "MyText",
        :project_id => 2
      )
    ])
  end

  it "renders a list of stories" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
