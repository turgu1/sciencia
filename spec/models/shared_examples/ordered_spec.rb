shared_examples_for "an ordered table" do |the_model|

 describe "Caption validation" do

    it "should have a non-blank caption" do
      expect(build(the_model, caption: "")).not_to be_valid
    end

    it "should have a unique caption" do
      create(the_model, caption: "The Model")
      expect(build(the_model, caption: "The Model")).not_to be_valid
    end
  end

  describe "Abbreviation validation" do

    it "should have a non-blank abbreviation" do
      expect(build(the_model, abbreviation: "")).not_to be_valid
    end

    it "should have a unique abbreviation" do
      create(the_model, abbreviation: "MOD")
      expect(build(the_model, abbreviation: "MOD")).not_to be_valid
    end
  end

  describe "Order validation" do

    it "should have an order number" do
      expect(build(the_model, order: nil)).not_to be_valid
    end

    it "should not accept negative order number" do
      expect(build(the_model, order: -1)).not_to be_valid
    end
  end
end