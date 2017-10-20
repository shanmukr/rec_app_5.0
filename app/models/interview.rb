class Interview < ApplicationRecord

  belongs_to :requirement
  belongs_to :req_match
  belongs_to :employee

end
