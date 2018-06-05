require "spec_helper"

describe SecurityClassificationsController do
  describe "routing" do

    it "routes to #index" do
      get("/security_classifications").should route_to("security_classifications#index")
    end

    it "routes to #new" do
      get("/security_classifications/new").should route_to("security_classifications#new")
    end

    it "routes to #show" do
      get("/security_classifications/1").should route_to("security_classifications#show", :id => "1")
    end

    it "routes to #edit" do
      get("/security_classifications/1/edit").should route_to("security_classifications#edit", :id => "1")
    end

    it "routes to #create" do
      post("/security_classifications").should route_to("security_classifications#create")
    end

    it "routes to #update" do
      put("/security_classifications/1").should route_to("security_classifications#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/security_classifications/1").should route_to("security_classifications#destroy", :id => "1")
    end

  end
end
