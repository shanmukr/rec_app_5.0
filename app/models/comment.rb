class Comment < ApplicationRecord
 
  belongs_to   :employee
  belongs_to   :resume,
               :class_name  => "Resume",
               :foreign_key => "resume_id"

  def create_comment(comment, resume_id, emp_id, type)
	  @comment  = Comment.new
		@comment.comment = comment
		@comment.resume_id = resume_id
		@comment.ctype = type
		@comment.employee_id = emp_id
    @comment.save
	end

end
