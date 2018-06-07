require "spec_helper"

describe Dictionaries::PublishersController do
  describe "routing" do

    it "routes to #index" do
      get("/dictionaries/publishers").should route_to("dictionaries/publishers#index")
    end

    it "routes to #new" do
      get("/dictionaries/publishers/new").should route_to("dictionaries/publishers#new")
    end

    it "routes to #show" do
      get("/dictionaries/publishers/1").should route_to("dictionaries/publishers#show", id: "1")
    end

    it "routes to #edit" do
      get("/dictionaries/publishers/1/edit").should route_to("dictionaries/publishers#edit", id: "1")
    end

    it "routes to #create" do
      post("/dictionaries/publishers").should route_to("dictionaries/publishers#create")
    end

    it "routes to #update" do
      put("/dictionaries/publishers/1").should route_to("dictionaries/publishers#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/dictionaries/publishers/1").should route_to("dictionaries/publishers#destroy", id: "1")
    end

  end
end
