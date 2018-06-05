# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :journal, class: Dictionaries::Journal do
    sequence(:caption) { |n| "Journal-#{n}" }
  end
end
