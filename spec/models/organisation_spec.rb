require 'spec_helper'

describe Organisation do

  it "should create a new instance given valid attributes" do
    expect(create(:organisation)).to be_valid
  end

  it "should delete all people dependancies when destroyed" do
    org = create(:organisation)
    p = create_list(:person, 10, organisation: org)
    org.destroy
    p.each do |person|
      expect(Person.exists?(person)).to be_false
    end
  end

  describe "Abbreviation validation" do

    it "should have a non-blank abbreviation" do
      expect(build(:organisation, abbreviation: "")).not_to be_valid
    end

    it "should have a unique abbreviation" do
      create(:organisation, abbreviation: "OTH")
      expect(build(:organisation, abbreviation: "OTH")).not_to be_valid
    end
  end

  describe "Name validation" do

    it "should have a non-blank name" do
      expect(build(:organisation, name: "")).not_to be_valid
    end

    it "should have a unique name" do
      create(:organisation, name: "The Org")
      expect(build(:organisation, name: "The Org")).not_to be_valid
    end
  end

  describe "Order validation" do

    it "should have an order number" do
      expect(build(:organisation, order: nil)).not_to be_valid
    end

    it "should not accept negative order number" do
      expect(build(:organisation, order: -1)).not_to be_valid
    end
  end

  describe "people_count validation" do

    it "should be zero at organisation creation time" do
      org = create(:organisation)
      expect(org.people_count).to eq(0)
    end

    it "should be incremented when a new person is added" do
      org = create(:organisation)
      create(:person, organisation: org)
      org.reload
      expect(org.people_count).to eq(1)
    end      
  end

  describe "Automated get/creation on abbreviation search" do

    it "should return an existing organisation when the abbreviation is found" do
      org = create(:organisation, abbreviation: "SO")
      found_org = Organisation.get_or_create("SO")
      expect(org.id).to eq(found_org.id)
    end

    it "should return a new organisation when abbreviation is not found" do
      org = create(:organisation)
      found_org = Organisation.get_or_create("SI")
      expect(org.id).not_to eq(found_org.id) and
      expect(found_org).to be_valid
    end

    it "should mark the new organisation as other when abbreviation is not found" do
      org = create(:organisation)
      found_org = Organisation.get_or_create("SA")
      expect(org.id).not_to eq(found_org.id) and
      expect(found_org.other).to be_true and
      expect(found_org).to be_valid
    end
  end

  describe "People transfer to other organisation" do

    before (:each) do
      @org_source = create(:organisation)
      @org_destination = create(:organisation)
      create_list(:person, 10, organisation: @org_source)
    end

    it "should displace all person from on organisation to the other" do
      @org_source.do_replace(@org_destination, false)
      @org_source.reload
      @org_destination.reload
      expect(@org_source.people_count).to eq(0) and
      expect(@org_destination.people_count).to eq(10)
    end

    it "should destroy source organisation when required to do so" do
      @org_source.do_replace(@org_destination, true)
      @org_destination.reload
      expect(Organisation.exists?(name: @org_source.name)).to be_false
    end

    it "should return an informational message" do
      msg = @org_source.do_replace(@org_destination, true)
      expect(msg).to eq("[#{@org_source.name}] replaced with [#{@org_destination.name}] and deleted.")
    end
  end
end
