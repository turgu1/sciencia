# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :publisher, class: Dictionaries::Publisher do
    sequence(:caption) { |n| "Publisher-#{n}" }
  end
end
