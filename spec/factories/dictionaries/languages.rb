# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :language, class: Dictionaries::Language do
    sequence(:caption) { |n| "Language-#{n}" }
  end
end
