# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :school, class: Dictionaries::School do
    sequence(:caption) { |n| "School-#{n}" }
  end
end
