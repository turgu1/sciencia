require 'spec_helper'

describe "Dictionaries::Editors" do
  describe "GET /dictionaries_editors" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get dictionaries_editors_path
      response.status.should be(200)
    end
  end
end
