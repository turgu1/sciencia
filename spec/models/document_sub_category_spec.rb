require 'spec_helper'

describe DocumentSubCategory do

  it "should create a new instance given valid attributes" do
  	expect(build(:document_sub_category)).to be_valid
  end

  it_behaves_like "an ordered table", :document_sub_category

  it "should be pointing at a document category" do
  	expect(build(:document_sub_category, document_category: nil)).not_to be_valid
  end

end
