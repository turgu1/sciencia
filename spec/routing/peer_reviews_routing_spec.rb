require "spec_helper"

describe PeerReviewsController do
  describe "routing" do

    it "routes to #index" do
      get("/peer_reviews").should route_to("peer_reviews#index")
    end

    it "routes to #new" do
      get("/peer_reviews/new").should route_to("peer_reviews#new")
    end

    it "routes to #show" do
      get("/peer_reviews/1").should route_to("peer_reviews#show", :id => "1")
    end

    it "routes to #edit" do
      get("/peer_reviews/1/edit").should route_to("peer_reviews#edit", :id => "1")
    end

    it "routes to #create" do
      post("/peer_reviews").should route_to("peer_reviews#create")
    end

    it "routes to #update" do
      put("/peer_reviews/1").should route_to("peer_reviews#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/peer_reviews/1").should route_to("peer_reviews#destroy", :id => "1")
    end

  end
end
