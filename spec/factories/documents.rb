# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :document do
    title "Title of the document"
    security_classification
    peer_review
    document_type
    document_sub_category
    month 3
    year 2016
    people
  end
end
