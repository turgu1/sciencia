require 'spec_helper'

describe DocumentType do
  it "should create a new instance given valid attributes" do
    expect(build(:document_type)).to be_valid
  end

  it_behaves_like "an ordered table", :document_type

  it "should have a valid no-peer-review sub category" do
  	expect(build(:document_type, no_peer_review_sub_category: nil)).not_to be_valid
  end

  it "should have a valid peer-review sub category" do
  	expect(build(:document_type, peer_review_sub_category: nil)).not_to be_valid
  end
end
