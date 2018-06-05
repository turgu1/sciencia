# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :dictionaries_language, :class => 'Dictionaries::Language' do
    caption "MyString"
  end
end
