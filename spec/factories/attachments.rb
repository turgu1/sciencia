# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :attachment do
    document nil
    content_type "MyString"
    filename "MyString"
    thumbnail "MyString"
    size 1
    width 1
    height 1
    erased false
  end
end
