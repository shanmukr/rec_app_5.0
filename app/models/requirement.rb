class Requirement < ApplicationRecord

  belongs_to              :employee
  belongs_to              :group
  belongs_to              :designation
  belongs_to              :account
  belongs_to              :posted_by,
                          :class_name  => "Employee",
                          :foreign_key => "posting_emp_id"
  belongs_to              :group,
                          :class_name  => "Group",
                          :foreign_key => "group_id"
  has_many                :interviews
  has_many                :req_matches
  has_and_belongs_to_many :forwards

  validates_presence_of   :name, :employee_id, :nop, :designation_id, :skill, :sdate, :edate, :group_id, :status, :posting_emp_id, :req_type, :exp, :description
  validates_uniqueness_of :name
  auto_strip_attributes   :name, :squish => true

end
