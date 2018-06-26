require "rails_helper"

RSpec.describe EstimatesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/estimates").to route_to("estimates#index")
    end

    it "routes to #new" do
      expect(:get => "/estimates/new").to route_to("estimates#new")
    end

    it "routes to #show" do
      expect(:get => "/estimates/1").to route_to("estimates#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/estimates/1/edit").to route_to("estimates#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/estimates").to route_to("estimates#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/estimates/1").to route_to("estimates#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/estimates/1").to route_to("estimates#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/estimates/1").to route_to("estimates#destroy", :id => "1")
    end

  end
end
