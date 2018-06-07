require "spec_helper"

describe Dictionaries::OrgsController do
  describe "routing" do

    it "routes to #index" do
      get("/dictionaries/orgs").should route_to("dictionaries/orgs#index")
    end

    it "routes to #new" do
      get("/dictionaries/orgs/new").should route_to("dictionaries/orgs#new")
    end

    it "routes to #show" do
      get("/dictionaries/orgs/1").should route_to("dictionaries/orgs#show", id: "1")
    end

    it "routes to #edit" do
      get("/dictionaries/orgs/1/edit").should route_to("dictionaries/orgs#edit", id: "1")
    end

    it "routes to #create" do
      post("/dictionaries/orgs").should route_to("dictionaries/orgs#create")
    end

    it "routes to #update" do
      put("/dictionaries/orgs/1").should route_to("dictionaries/orgs#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/dictionaries/orgs/1").should route_to("dictionaries/orgs#destroy", id: "1")
    end

  end
end
