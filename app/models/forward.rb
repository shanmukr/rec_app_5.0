class Forward < ApplicationRecord
 
  belongs_to                 :forwarded_to,
                             :class_name  => "Employee",
                             :foreign_key => "forwarded_to"
  belongs_to                 :forwarded_by,
                             :class_name  => "Employee",
                             :foreign_key => "forwarded_by"
  belongs_to                 :resume
  has_and_belongs_to_many    :requirements

  def create_forwards(cur_emp, resume_id, status, req_id)
		  @forwards                = Forward.new
		  @forwards.forwarded_by   = cur_emp
		  @forwards.resume_id      = resume_id
			emp                      = Requirement.find(req_id)
			@forwards.forwarded_to   = Employee.find(emp.employee_id)   
			@forwards.status         = status 
      @forwards.save
			@forwards.requirements << emp #Requirement.find(req_id)
	end

end
