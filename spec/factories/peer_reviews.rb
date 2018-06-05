# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :peer_review do
    sequence(:caption) { |n| "Peer Review-#{n}" }
    sequence(:abbreviation) { |n| "Peer-#{n}" }
    order 1
  end
end
