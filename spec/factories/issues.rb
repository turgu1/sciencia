# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :issue do
    title "MyString"
    state 1
    type 1
    user nil
  end
end
