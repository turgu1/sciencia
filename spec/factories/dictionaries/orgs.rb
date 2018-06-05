# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :org, class: Dictionaries::Org do
    sequence(:caption) { |n| "Org-#{n}" }
  end
end
