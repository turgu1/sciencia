require 'spec_helper'

describe DocumentCategory do

  it "should create a new instance given valid attributes" do
  	expect(build(:document_category)).to be_valid
  end

  it_behaves_like "an ordered table", :document_category
  
end
