# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :person do
    sequence(:first_name) { |n| "First-Name-#{n}" }
    last_name "Last-Name"
    email "toto@toto.com"
    phone "555-1212"
    organisation
  end
end
