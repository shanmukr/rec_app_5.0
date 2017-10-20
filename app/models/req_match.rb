class ReqMatch < ApplicationRecord

  belongs_to :resume
  has_many   :interviews
  belongs_to :requirement
  belongs_to :forwarded_to,
             :class_name  => "Employee",
             :foreign_key => "forwarded_to"

end
