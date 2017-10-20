class Resume < ApplicationRecord

  belongs_to               :uniqid
  belongs_to               :employee
  has_many                 :feedbacks
  has_many                 :messages
  has_many                 :forwards,
                           :class_name  => "Forward",
                           :foreign_key => "resume_id"
  has_many                 :req_matches,
                           :class_name  => "ReqMatch",
                           :foreign_key => "resume_id"
  has_many                 :comments,
                           :class_name  => "Comment",
                           :foreign_key => "resume_id"

  validates_presence_of    :name, :phone, :email, :experience, :ctc, :notice, :current_company, :location 
  validates_uniqueness_of  :file_name, :phone, :email
  auto_strip_attributes    :name, :squish => true
  validates_format_of      :email, :with => /([\w]+)@([\w]+)\.com/

end
