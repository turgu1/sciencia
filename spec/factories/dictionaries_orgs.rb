# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :dictionaries_org, :class => 'Dictionaries::Org' do
    caption "MyString"
  end
end
