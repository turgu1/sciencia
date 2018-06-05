require "spec_helper"

describe Dictionaries::JournalsController do
  describe "routing" do

    it "routes to #index" do
      get("/dictionaries/journals").should route_to("dictionaries/journals#index")
    end

    it "routes to #new" do
      get("/dictionaries/journals/new").should route_to("dictionaries/journals#new")
    end

    it "routes to #show" do
      get("/dictionaries/journals/1").should route_to("dictionaries/journals#show", :id => "1")
    end

    it "routes to #edit" do
      get("/dictionaries/journals/1/edit").should route_to("dictionaries/journals#edit", :id => "1")
    end

    it "routes to #create" do
      post("/dictionaries/journals").should route_to("dictionaries/journals#create")
    end

    it "routes to #update" do
      put("/dictionaries/journals/1").should route_to("dictionaries/journals#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/dictionaries/journals/1").should route_to("dictionaries/journals#destroy", :id => "1")
    end

  end
end
