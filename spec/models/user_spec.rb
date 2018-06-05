require 'spec_helper'

describe User do

  it "should create a new instance given valid attributes" do
    expect(build(:user)).to be_valid
  end

  it "should require an email address" do
    expect(build(:user, email: "")).not_to be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = build(:user, email: address)
      expect(valid_email_user).to be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = build(:user, email: address)
      expect(invalid_email_user).not_to be_valid
    end
  end

  it "should reject duplicate usernames" do
    create(:user, username: "user", email: "user1@toto.com")
    expect(build(:user, username: "user", email: "user2@toto.com")).not_to be_valid
  end

  it "should reject duplicate email addresses" do
    create(:user, username: "user1", email: "user3@toto.com")
    expect(build(:user, username: "user2", email: "user3@toto.com")).not_to be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = "user4@toto.com".upcase
    create(:user, email: upcased_email)
    user_with_duplicate_email = build(:user, email: "user4@toto.com")
    expect(user_with_duplicate_email).not_to be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = create(:user)
    end

    it "should have a password attribute" do
      expect(@user).to respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      expect(@user).to respond_to(:password_confirmation)
    end
  end

  describe "automatic linkage with a person" do

    it "should link with a person if email match" do
      person = create(:person, email: "match1@match.com")
      linked_user = create(:user, email: "match1@match.com")
      expect(linked_user.person).not_to(eq(nil)) and 
      expect(linked_user.person.id).to(eq(person.id))
    end

    it "should not link with a person if email doesn't match" do
      person = create(:person, email: "match2@match.com")
      unlinked_user = create(:user, email: "nomatch2@match.com")
      expect(unlinked_user.person).to eq(nil)
    end
    
  end

  describe "role" do
    
    it "should get :user role if linked with a person" do
      person = create(:person, email: "match3@match.com")
      linked_user = create(:user, email: "match3@match.com")
      expect(linked_user.roles).to eq(["user"]) 
    end

    it "should not get any role if not linked with a person" do
      person = create(:person, email: "match4@match.com")
      unlinked_user = create(:user, email: "nomatch4@match.com")
      expect(unlinked_user.person).to(eq(nil)) and 
      expect(unlinked_user.roles).to(be_empty)
    end 
  end

  describe "password validations" do

    it "should require a password" do
      expect(build(:user, password: "", password_confirmation: "")).
        not_to be_valid
    end

    it "should require a matching password confirmation" do
      expect(build(:user, password_confirmation: "invalid")).
        not_to be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = { password: short, password_confirmation: short }
      expect(build(:user, hash)).not_to be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = create(:user)
    end

    it "should have an encrypted password attribute" do
      expect(@user).to respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      expect(@user.encrypted_password).not_to be_blank
    end

  end

end
