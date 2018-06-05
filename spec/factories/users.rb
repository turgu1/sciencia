# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "TestUser-#{n}" }
    sequence(:email)    { |n| "example#{n}@example.com" }
    password              'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end
