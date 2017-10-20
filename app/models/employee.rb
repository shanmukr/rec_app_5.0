class Employee < ApplicationRecord

  has_many    :sessions
  has_many    :comments
  has_many    :interviews
  has_many    :feedbacks
  has_many    :requirements,
              :class_name  => "Requirement",
              :foreign_key => "employee_id"
  has_many    :to_schedule_reqs,
              :class_name => "Requirement",
              :foreign_key => "scheduling_employee_id"
  has_many    :forwards,
              :class_name  => "Forward",
              :foreign_key => "forwarded_to"
  has_many    :req_matches,
              :class_name  => "ReqMatch",
              :foreign_key => "forwarded_to"
  has_many    :resumes,
              :class_name  => "Resume",
              :foreign_key => "employee_id"
  has_many    :in_messages,
              :class_name  => "Message",
              :foreign_key => "sent_to"
  has_many    :out_messages,
              :class_name  => "Message",
              :foreign_key => "sent_by"
  belongs_to  :group,
              :class_name  => "Group",
              :foreign_key => "group_id"
  belongs_to  :manager,
              :class_name => "Employee",
              :foreign_key => "manager_id"

end
