# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :document_sub_category do
    sequence(:caption) { |n| "Document Sub Category #{n}" }
    sequence(:abbreviation) { |n| "DSC#{n}" }
    order 1
    document_category
    peer_review_required false
    sl false
  end
end
