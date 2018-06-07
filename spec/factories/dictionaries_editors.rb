# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :dictionaries_editor, class: 'Dictionaries::Editor' do
    caption "MyString"
  end
end
