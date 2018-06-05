require "spec_helper"

describe Dictionaries::InstitutionsController do
  describe "routing" do

    it "routes to #index" do
      get("/dictionaries/institutions").should route_to("dictionaries/institutions#index")
    end

    it "routes to #new" do
      get("/dictionaries/institutions/new").should route_to("dictionaries/institutions#new")
    end

    it "routes to #show" do
      get("/dictionaries/institutions/1").should route_to("dictionaries/institutions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/dictionaries/institutions/1/edit").should route_to("dictionaries/institutions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/dictionaries/institutions").should route_to("dictionaries/institutions#create")
    end

    it "routes to #update" do
      put("/dictionaries/institutions/1").should route_to("dictionaries/institutions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/dictionaries/institutions/1").should route_to("dictionaries/institutions#destroy", :id => "1")
    end

  end
end
