require 'spec_helper'

describe Person do
  
  it "should create a new instance given valid attributes" do
    expect(create(:person)).to be_valid
  end

  it "should be pointing to an organisation" do
    expect(build(:person, organisation: nil)).not_to be_valid
  end

  describe "name validation" do

    it "should have a valid first name" do
      expect(build(:person, first_name: "")).not_to be_valid
    end

    it "should have a valid last_name" do
      expect(build(:person, last_name: "")).not_to be_valid
    end
  end

  describe "when destroyed" do

    it "should be deleted when he is *not* an author" do
      p = create(:person)
      p.destroy
      expect(Person.exists?(p)).to be_false
    end

    it "should be moved to special *Retrait* organisation when he is an author" do
      p = create(:person)
      p.destroy
      expect(Person.exists?(p)).to(be_true) and
      expect(Organisation.exists?(p.organisation)).to(be_true) and
      expect(p.organisation.name).to(eq("Retrait"))
    end
  end

end
