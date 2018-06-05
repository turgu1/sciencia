# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :editor, class: Dictionaries::Editor do
    sequence(:caption) { |n| "Editor-#{n}" }
  end
end
