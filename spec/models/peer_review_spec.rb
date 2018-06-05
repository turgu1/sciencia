require 'spec_helper'

describe PeerReview do
  
  it "should create a new instance given valid attributes" do
    expect(build(:peer_review)).to be_valid
  end

  it_behaves_like "an ordered table", :peer_review

end
