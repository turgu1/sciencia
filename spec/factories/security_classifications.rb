# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :security_classification do
    sequence(:caption) { |n| "Sec Class-#{n}" }
    sequence(:abbreviation) { |n| "SC#{n}" }
    order 1
  end
end
