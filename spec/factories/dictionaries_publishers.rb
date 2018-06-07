# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :dictionaries_publisher, class: 'Dictionaries::Publisher' do
    caption "MyString"
  end
end
