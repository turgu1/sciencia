# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :institution, class: Dictionaries::Institution do
    sequence(:caption) { |n| "Institution-#{n}" }
  end
end
