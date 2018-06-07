require "spec_helper"

describe DocumentCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/document_categories").should route_to("document_categories#index")
    end

    it "routes to #new" do
      get("/document_categories/new").should route_to("document_categories#new")
    end

    it "routes to #show" do
      get("/document_categories/1").should route_to("document_categories#show", id: "1")
    end

    it "routes to #edit" do
      get("/document_categories/1/edit").should route_to("document_categories#edit", id: "1")
    end

    it "routes to #create" do
      post("/document_categories").should route_to("document_categories#create")
    end

    it "routes to #update" do
      put("/document_categories/1").should route_to("document_categories#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/document_categories/1").should route_to("document_categories#destroy", id: "1")
    end

  end
end
