require "spec_helper"

describe Dictionaries::LanguagesController do
  describe "routing" do

    it "routes to #index" do
      get("/dictionaries/languages").should route_to("dictionaries/languages#index")
    end

    it "routes to #new" do
      get("/dictionaries/languages/new").should route_to("dictionaries/languages#new")
    end

    it "routes to #show" do
      get("/dictionaries/languages/1").should route_to("dictionaries/languages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/dictionaries/languages/1/edit").should route_to("dictionaries/languages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/dictionaries/languages").should route_to("dictionaries/languages#create")
    end

    it "routes to #update" do
      put("/dictionaries/languages/1").should route_to("dictionaries/languages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/dictionaries/languages/1").should route_to("dictionaries/languages#destroy", :id => "1")
    end

  end
end
