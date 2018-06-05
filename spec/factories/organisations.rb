# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :organisation do
    sequence (:name) { |n| "Some Organisation-#{n}" }
    sequence (:abbreviation) { |n| "SO-#{n}" }
    order 1
  end
end
