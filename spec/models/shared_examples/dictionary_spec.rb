require 'spec_helper'

shared_examples_for 'a dictionary' do |the_model|

  let(:dictionary) { described_class.new }

  it "should create a new instance given valid attributes" do
  	expect(build(the_model)).to be_valid
  end

  it "should reject an entry without a caption" do
  	expect(build(the_model, caption: "")).not_to be_valid
  end

  it "should reject a second entry with the same caption" do
  	create(the_model, caption: "First entry");
  	expect(build(the_model, caption: "First entry")).not_to be_valid
  end
end
