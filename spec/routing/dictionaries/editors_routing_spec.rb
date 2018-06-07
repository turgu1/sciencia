require "spec_helper"

describe Dictionaries::EditorsController do
  describe "routing" do

    it "routes to #index" do
      get("/dictionaries/editors").should route_to("dictionaries/editors#index")
    end

    it "routes to #new" do
      get("/dictionaries/editors/new").should route_to("dictionaries/editors#new")
    end

    it "routes to #show" do
      get("/dictionaries/editors/1").should route_to("dictionaries/editors#show", id: "1")
    end

    it "routes to #edit" do
      get("/dictionaries/editors/1/edit").should route_to("dictionaries/editors#edit", id: "1")
    end

    it "routes to #create" do
      post("/dictionaries/editors").should route_to("dictionaries/editors#create")
    end

    it "routes to #update" do
      put("/dictionaries/editors/1").should route_to("dictionaries/editors#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/dictionaries/editors/1").should route_to("dictionaries/editors#destroy", id: "1")
    end

  end
end
