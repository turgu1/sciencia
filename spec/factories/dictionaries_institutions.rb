# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :dictionaries_institution, :class => 'Dictionaries::Institution' do
    caption "MyString"
  end
end
