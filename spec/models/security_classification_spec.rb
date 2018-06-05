require 'spec_helper'

describe SecurityClassification do

  it "should create a new instance given valid attributes" do
    expect(build(:security_classification)).to be_valid
  end

  it_behaves_like "an ordered table", :security_classification

end
