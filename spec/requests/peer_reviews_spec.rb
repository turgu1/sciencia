require 'spec_helper'

describe "PeerReviews" do
  describe "GET /peer_reviews" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get peer_reviews_path
      response.status.should be(200)
    end
  end
end
