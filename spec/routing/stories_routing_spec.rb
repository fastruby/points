require "rails_helper"

RSpec.describe StoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/stories").to route_to("stories#index")
    end

    it "routes to #new" do
      expect(:get => "/stories/new").to route_to("stories#new")
    end

    it "routes to #show" do
      expect(:get => "/stories/1").to route_to("stories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/stories/1/edit").to route_to("stories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/stories").to route_to("stories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/stories/1").to route_to("stories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/stories/1").to route_to("stories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/stories/1").to route_to("stories#destroy", :id => "1")
    end

  end
end
