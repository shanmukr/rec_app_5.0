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

ActiveRecord::Schema.define(version: 20170324070522) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.integer  "acc_manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "accounts_requirements", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "requirement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["requirement_id", "account_id"], name: "index_accounts_requirements_on_requirement_id_and_account_id", unique: true, using: :btree
    t.index ["requirement_id"], name: "index_accounts_requirements_on_requirement_id", using: :btree
  end

  create_table "accumulated_leaves", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "year"
    t.integer  "employee_id"
    t.float    "accumulated_leaves_last_year", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment",                      limit: 65535
  end

  create_table "agencies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approvals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "approver_id",            default: 0,         null: false
    t.integer  "leave_id",               default: 0,         null: false
    t.string   "status",      limit: 15, default: "PENDING"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.text     "comment",     limit: 65535
    t.integer  "leave_id",                  default: 0,      null: false
    t.integer  "employee_id",               default: 0,      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resume_id",                 default: 0,      null: false
    t.string   "ctype",       limit: 10,    default: "USER"
    t.index ["resume_id"], name: "resume_comments", using: :btree
  end

  create_table "designations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.integer  "eid"
    t.string   "login"
    t.string   "email"
    t.integer  "manager_id"
    t.string   "employee_type"
    t.string   "employee_status", default: "ACTIVE"
    t.integer  "account_id"
    t.boolean  "is_admin",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "joining_date"
    t.date     "leaving_date"
    t.integer  "group_id"
  end

  create_table "employees_issues", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "employee_id"
    t.integer  "issue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["employee_id", "issue_id"], name: "index_employees_issues_on_employee_id_and_issue_id", unique: true, using: :btree
    t.index ["employee_id"], name: "index_employees_issues_on_employee_id", using: :btree
    t.index ["issue_id"], name: "index_employees_issues_on_issue_id", using: :btree
  end

  create_table "engagement_snapshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "employee_id",                default: 0, null: false
    t.integer  "account_id",                 default: 0, null: false
    t.integer  "approved_by",                default: 0, null: false
    t.date     "date",                                   null: false
    t.text     "comment",      limit: 65535
    t.integer  "billing_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engagements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.date     "sdate"
    t.date     "edate"
    t.integer  "employee_id",                 default: 0,     null: false
    t.integer  "account_id",                  default: 0,     null: false
    t.integer  "billing_rate"
    t.float    "fraction_billing", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "service_tax",                 default: false
  end

  create_table "expense_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "frequency"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expenses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "expense_type_id"
    t.integer  "month"
    t.integer  "year"
    t.integer  "amount"
    t.integer  "added_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "resume_id",                 default: 0,  null: false
    t.integer  "employee_id",               default: 0,  null: false
    t.string   "rating",      limit: 20,    default: "", null: false
    t.text     "feedback",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["resume_id"], name: "resume_feedbacks", using: :btree
  end

  create_table "forwards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "forwarded_to",            default: 0,     null: false
    t.integer  "resume_id",               default: 0,     null: false
    t.string   "status",       limit: 15, default: "NEW"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forwarded_by"
    t.index ["resume_id"], name: "resume_forwards", using: :btree
  end

  create_table "forwards_requirements", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "forward_id"
    t.integer  "requirement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["requirement_id", "forward_id"], name: "index_forwards_requirements_on_requirement_id_and_forward_id", unique: true, using: :btree
    t.index ["requirement_id"], name: "index_forwards_requirements_on_requirement_id", using: :btree
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name",        default: "", null: false
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.date     "holiday_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "employee_id",                  default: 0,                     null: false
    t.date     "interview_date"
    t.time     "interview_time",               default: '2000-01-01 00:00:00'
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "req_match_id",                 default: 0,                     null: false
    t.string   "status",         limit: 10,    default: "NEW"
    t.string   "stage"
    t.string   "itype"
    t.text     "focus",          limit: 65535
    t.index ["req_match_id"], name: "req_match_interviews", using: :btree
  end

  create_table "issue_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "employee_id"
    t.integer  "issue_id"
    t.string   "type"
    t.text     "body",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "owned_by_id"
    t.date     "target_date"
    t.string   "status"
    t.string   "department"
    t.text     "body",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uid"
    t.string   "title"
    t.integer  "added_by_id"
  end

  create_table "issues_oneonones", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "oneonone_id"
    t.integer  "issue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["oneonone_id", "issue_id"], name: "index_issues_oneonones_on_oneonone_id_and_issue_id", unique: true, using: :btree
    t.index ["oneonone_id"], name: "index_issues_oneonones_on_oneonone_id", using: :btree
  end

  create_table "leaves", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "employee_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "leave_type",                default: "CL"
    t.text     "reason",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "is_half_day", limit: 1,     default: 0
  end

  create_table "leaves_snapshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "employee_id"
    t.integer  "cl",                        default: 0
    t.integer  "el",                        default: 0
    t.integer  "sl",                        default: 0
    t.date     "date"
    t.text     "comment",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.text     "message",    limit: 65535
    t.integer  "resume_id"
    t.integer  "sent_to",                  default: 0, null: false
    t.integer  "sent_by",                  default: 0, null: false
    t.integer  "reply_to"
    t.boolean  "is_deleted"
    t.boolean  "is_read"
    t.boolean  "is_replied"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["resume_id"], name: "resume_messages", using: :btree
  end

  create_table "oneonones", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.date     "date"
    t.text     "body",        limit: 65535
    t.string   "status"
    t.string   "filename"
    t.integer  "employee_id"
    t.integer  "manager_id"
    t.integer  "added_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "req_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.text     "comment",     limit: 65535
    t.integer  "resume_id",                 default: 0, null: false
    t.integer  "employee_id",               default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "req_matches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "forwarded_to",                default: 0,     null: false
    t.integer  "resume_id",                   default: 0,     null: false
    t.integer  "requirement_id",              default: 0,     null: false
    t.string   "status",           limit: 15, default: "NEW"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "interview_status",            default: ""
    t.index ["resume_id"], name: "resume_req_match", using: :btree
    t.index ["status"], name: "status_reqmatches", using: :btree
  end

  create_table "requirements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name",                                 default: "",         null: false
    t.integer  "posting_emp_id"
    t.integer  "employee_id"
    t.integer  "uniqid_id"
    t.text     "skill",                  limit: 65535
    t.text     "description",            limit: 65535
    t.string   "exp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                               default: "OPEN"
    t.integer  "group_id"
    t.date     "sdate"
    t.date     "edate"
    t.integer  "nop",                                  default: 1
    t.string   "req_type",                             default: "ORDINARY"
    t.integer  "source_owner"
    t.integer  "schedule_owner"
    t.text     "mgt_comment",            limit: 65535
    t.integer  "designation_id"
    t.integer  "scheduling_employee_id"
    t.integer  "account_id"
  end

  create_table "resumes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name",                               default: "",  null: false
    t.string   "file_name",                          default: "",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id",                        default: 0,   null: false
    t.text     "summary",              limit: 65535,               null: false
    t.text     "search_data",          limit: 65535
    t.integer  "uniqid_id"
    t.string   "referral_type",        limit: 15,    default: "",  null: false
    t.integer  "referral_id",                        default: 0,   null: false
    t.string   "email"
    t.string   "phone"
    t.date     "joining_date"
    t.string   "experience"
    t.text     "qualification",        limit: 65535
    t.float    "ctc",                  limit: 24
    t.float    "expected_ctc",         limit: 24
    t.integer  "notice"
    t.string   "status",               limit: 10,    default: ""
    t.string   "current_company"
    t.string   "location"
    t.integer  "nreq_matches",                       default: 0
    t.integer  "nforwards",                          default: 0
    t.string   "manual_status"
    t.integer  "exp_in_months"
    t.string   "overall_status"
    t.string   "related_requirements"
    t.string   "likely_to_join",       limit: 1,     default: "R"
    t.string   "skype_id"
    t.index ["status"], name: "index_resumes_on_status", using: :btree
    t.index ["status"], name: "status_resumes", using: :btree
    t.index ["uniqid_id"], name: "uniqid_resumes", using: :btree
  end

  create_table "salaries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "employee_id",                   default: 0, null: false
    t.integer  "basic",                         default: 0
    t.integer  "hra",                           default: 0
    t.integer  "pfa",                           default: 0
    t.date     "sdate"
    t.text     "comment",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conveyance"
    t.integer  "medical"
    t.integer  "flexi_allowance"
    t.integer  "incentive"
    t.integer  "kcb"
    t.integer  "bonus"
    t.integer  "da"
    t.integer  "gym"
    t.integer  "others"
  end

  create_table "salary_snapshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "employee_id",                   default: 0, null: false
    t.integer  "approved_by",                   default: 0, null: false
    t.integer  "basic",                         default: 0
    t.integer  "hra",                           default: 0
    t.integer  "pfa",                           default: 0
    t.date     "date",                                      null: false
    t.text     "comment",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conveyance",                    default: 0
    t.integer  "medical",                       default: 0
    t.integer  "flexi_allowance",               default: 0
    t.integer  "incentive",                     default: 0
    t.integer  "kcb",                           default: 0
    t.integer  "bonus",                         default: 0
    t.integer  "da",                            default: 0
    t.integer  "gym",                           default: 0
    t.integer  "others",                        default: 0
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "session_id",               default: "", null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "temp_engagement_snapshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.date     "sdate"
    t.date     "edate"
    t.integer  "approved_by",                 default: 0, null: false
    t.integer  "employee_id",                 default: 0, null: false
    t.integer  "account_id",                  default: 0, null: false
    t.integer  "billing_rate"
    t.float    "fraction_billing", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_salary_snapshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "employee_id",                   default: 0, null: false
    t.integer  "approved_by",                   default: 0, null: false
    t.integer  "basic",                         default: 0
    t.integer  "hra",                           default: 0
    t.integer  "pfa",                           default: 0
    t.date     "date",                                      null: false
    t.text     "comment",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conveyance",                    default: 0
    t.integer  "medical",                       default: 0
    t.integer  "flexi_allowance",               default: 0
    t.integer  "incentive",                     default: 0
    t.integer  "kcb",                           default: 0
    t.integer  "bonus",                         default: 0
    t.integer  "da",                            default: 0
    t.integer  "gym",                           default: 0
    t.integer  "others",                        default: 0
  end

  create_table "uniqids", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.date     "date"
    t.integer  "month"
    t.integer  "year"
    t.text     "body",        limit: 65535
    t.string   "filename"
    t.integer  "employee_id"
    t.integer  "added_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
