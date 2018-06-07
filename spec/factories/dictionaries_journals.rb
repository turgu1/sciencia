# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :dictionaries_journal, class: 'Dictionaries::Journal' do
    caption "MyString"
  end
end
