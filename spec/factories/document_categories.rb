# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :document_category do
    sequence(:caption) { |n| "Document Category #{n} " }
    sequence(:abbreviation) { |n| "Cat #{n}" } 
    order 1
    rtf_header "The header"
    rtf_footer "The footer"
  end
end
