# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :dictionaries_school, class: 'Dictionaries::School' do
    caption "MyString"
  end
end
