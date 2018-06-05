# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :author do
    person nil
    document nil
    main_author false
    hidden false
    order 1
  end
end
