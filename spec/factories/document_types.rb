# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :document_type do
    sequence(:caption) { |n| "Document Type #{n}" }
    sequence(:abbreviation) { |n| "DT#{n}" }
    order 1
    synonyms "Document Type"
    field_list ":title"
    report_field_list ":title"
    peer_review_document_sub_category
    no_peer_review_document_sub_category
  end
end
