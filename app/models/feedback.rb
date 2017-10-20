class Feedback < ApplicationRecord
 
  belongs_to   :employee
  belongs_to   :resume,
               :foreign_key => "resume_id"
end
