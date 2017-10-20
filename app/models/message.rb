class Message < ApplicationRecord

  belongs_to            :resume
  belongs_to            :sent_to,
                        :class_name  => "Employee",
                        :foreign_key => "sent_to"
  belongs_to            :sent_by,
                        :class_name  => "Employee",
                        :foreign_key => "sent_by"

end
