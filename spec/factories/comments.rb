# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :comment do
    comment "MyText"
    user nil
    entry_time "2013-10-21 01:17:26"
    issue nil
  end
end
