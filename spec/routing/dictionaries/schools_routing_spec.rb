require "spec_helper"

describe Dictionaries::SchoolsController do
  describe "routing" do

    it "routes to #index" do
      get("/dictionaries/schools").should route_to("dictionaries/schools#index")
    end

    it "routes to #new" do
      get("/dictionaries/schools/new").should route_to("dictionaries/schools#new")
    end

    it "routes to #show" do
      get("/dictionaries/schools/1").should route_to("dictionaries/schools#show", id: "1")
    end

    it "routes to #edit" do
      get("/dictionaries/schools/1/edit").should route_to("dictionaries/schools#edit", id: "1")
    end

    it "routes to #create" do
      post("/dictionaries/schools").should route_to("dictionaries/schools#create")
    end

    it "routes to #update" do
      put("/dictionaries/schools/1").should route_to("dictionaries/schools#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/dictionaries/schools/1").should route_to("dictionaries/schools#destroy", id: "1")
    end

  end
end
