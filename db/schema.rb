# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_11_24_123245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.bigint "document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "doc_file"
    t.index ["document_id"], name: "index_attachments_on_document_id"
  end

  create_table "authors", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "document_id"
    t.boolean "main_author", default: true
    t.boolean "hidden", default: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_authors_on_document_id"
    t.index ["person_id"], name: "index_authors_on_person_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment"
    t.datetime "entry_time"
    t.bigint "user_id"
    t.bigint "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_comments_on_issue_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "document_categories", force: :cascade do |t|
    t.string "caption"
    t.string "abbreviation"
    t.integer "order"
    t.text "rtf_header"
    t.text "rtf_footer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_sub_categories", force: :cascade do |t|
    t.string "caption"
    t.string "abbreviation"
    t.integer "order"
    t.bigint "document_category_id"
    t.boolean "peer_review_required"
    t.boolean "sl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "translation_id"
    t.index ["document_category_id"], name: "index_document_sub_categories_on_document_category_id"
    t.index ["translation_id"], name: "index_document_sub_categories_on_translation_id"
  end

  create_table "document_types", force: :cascade do |t|
    t.string "caption"
    t.string "abbreviation"
    t.integer "order"
    t.string "synonyms"
    t.string "field_list"
    t.string "report_field_list"
    t.integer "peer_review_document_sub_category_id"
    t.integer "no_peer_review_document_sub_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden_author"
    t.index ["no_peer_review_document_sub_category_id"], name: "index_document_types_on_no_peer_review_document_sub_category_id"
    t.index ["peer_review_document_sub_category_id"], name: "index_document_types_on_peer_review_document_sub_category_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.string "document_reference"
    t.bigint "security_classification_id"
    t.bigint "peer_review_id"
    t.string "page_count"
    t.string "pages_reference"
    t.bigint "document_type_id"
    t.string "address"
    t.text "annote"
    t.string "booktitle"
    t.string "chapter"
    t.string "edition"
    t.bigint "editor_id"
    t.string "howpublished"
    t.bigint "institution_id"
    t.string "key"
    t.integer "month"
    t.text "note"
    t.integer "number"
    t.bigint "org_id"
    t.bigint "publisher_id"
    t.bigint "school_id"
    t.string "series"
    t.integer "volume"
    t.integer "year"
    t.text "abstract"
    t.text "contents"
    t.string "copyright"
    t.string "isbn"
    t.string "issn"
    t.string "keywords"
    t.bigint "language_id"
    t.string "location"
    t.string "lccn"
    t.string "url"
    t.bigint "document_sub_category_id"
    t.bigint "journal_id"
    t.bigint "last_update_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_sub_category_id"], name: "index_documents_on_document_sub_category_id"
    t.index ["document_type_id"], name: "index_documents_on_document_type_id"
    t.index ["editor_id"], name: "index_documents_on_editor_id"
    t.index ["institution_id"], name: "index_documents_on_institution_id"
    t.index ["journal_id"], name: "index_documents_on_journal_id"
    t.index ["language_id"], name: "index_documents_on_language_id"
    t.index ["last_update_by_id"], name: "index_documents_on_last_update_by_id"
    t.index ["org_id"], name: "index_documents_on_org_id"
    t.index ["peer_review_id"], name: "index_documents_on_peer_review_id"
    t.index ["publisher_id"], name: "index_documents_on_publisher_id"
    t.index ["school_id"], name: "index_documents_on_school_id"
    t.index ["security_classification_id"], name: "index_documents_on_security_classification_id"
  end

  create_table "editors", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "description"
    t.integer "month"
    t.integer "year"
    t.bigint "author_id"
    t.bigint "document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_events_on_author_id"
    t.index ["document_id"], name: "index_events_on_document_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", force: :cascade do |t|
    t.string "title"
    t.string "state"
    t.string "issue_type"
    t.bigint "user_id"
    t.datetime "last_update"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "journals", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.integer "people_count", default: 0
    t.boolean "other", default: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisations_users", id: false, force: :cascade do |t|
    t.bigint "organisation_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_organisations_users_on_organisation_id"
    t.index ["user_id"], name: "index_organisations_users_on_user_id"
  end

  create_table "orgs", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "peer_reviews", force: :cascade do |t|
    t.string "caption"
    t.string "abbreviation"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.bigint "organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "authors_count", default: 0
    t.index ["organisation_id"], name: "index_people_on_organisation_id"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "caption"
    t.string "reference_prefix"
    t.boolean "is_a_reference_prefix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "security_classifications", force: :cascade do |t|
    t.string "caption"
    t.string "abbreviation"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "title_marker", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "roles", default: [], array: true
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "theme"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
