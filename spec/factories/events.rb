# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :event do
    description "MyString"
    month 1
    year 1
    author nil
    document nil
  end
end
