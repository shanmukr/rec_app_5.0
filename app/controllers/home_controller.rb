class HomeController < ApplicationController

  def index
  end

  def emp_validation
    cur_emp = params[:emp_name]
    set_logged_emp(cur_emp)
    password = params[:password]
    obj = get_logged_employee
    if obj.present?
		  if obj.employee_type == "HR"
			  redirect_to :controller => "resumes", :action => "resumes_new" 
		  elsif obj.employee_type == "INDIVIDUAL" || obj.employee_type == "ADMIN"
			  redirect_to :controller => "resumes", :action => "forwarded" 
		  elsif obj.employee_type == "MANAGER"
			  redirect_to :controller => "resumes", :action => "my_interviews" 
			end
    else
      flash[:danger] = "The Given Employee (#{cur_emp}) is not found in our database Please contact Administrator"
    end
  end
  
	def logout
	  session.delete(:logged_emp)
	  session.delete(:cur_employee)
		render "index"
	end

end
