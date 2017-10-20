class EmployeesController < ApplicationController

  def index
    @employees = Employee.where(:employee_status => "ACTIVE").order(:name)
	  render "index"	
  end

  def login_to_selected_employee
		set_logged_emp(params[:login])
	  render "resumes/index"	
  end

	def my_employees
	  cur_emp = get_logged_employee
		#raise cur_emp.eid.inspect
    @employees = Employee.where(:manager_id => cur_emp.eid).order(:name)
	  render "index"	
	end

end
