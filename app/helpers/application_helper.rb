module ApplicationHelper

  def logged_cur_emp 
    obj = session[:cur_employee]
    obj
  end
  
	def print_interview_time(time, date)
		a = DateTime.parse([ date, time.strftime("%H:%M") ].join(' '))
    a.strftime('%b %d, %Y (%I:%M %P)')
  end
  
  def print_date_time(date)
    date.strftime('%b %d, %Y (%I:%M %P)')
  end

  def print_date(date)
    date.strftime("%b %d, %Y")
  end

  def get_owner_name(id)
    emp = Employee.find(id)
    emp.login
  end

  def get_emp_id(name)
   emp_details = Employee.find(name)
   emp_details.eid
  end

  def get_experience_inyears
    exp_inyears = []
    for i in 0 .. 15
      exp_inyears << i
    end
  end

  def get_experience_in_months
    exp_in_months = []
    for i in 0 .. 12
      exp_in_months << i
    end
  end

  def req_status
    status = [ "OPEN", "CLOSED EXPERIED", "CLOSED OFFERED", "CLOSED JOINING", "CLOSED DELETE" ]
    return status
  end

  def actions_for_select
    actions = [ "Add Comment", "Forward to", "Message", "Shortlist", "Reject", "Hold", "Offer", "Joining" ]
    return actions
  end

  def select_referals
    referals = [ "Group", "Portal", "Direct", "Agency" ]
    return referals
  end

  def req_exists(all_reqs, curr_req)
    all_reqs
  end

  def get_forwarded_resumes(forward)
    emp  = logged_cur_emp
		if emp.employee_type == "HR" || emp.employee_type == "ADMIN"
      reqs = forward.forwards.where(:status => "FORWARDED").map{|forward| [forward.requirements.collect(&:name).join(","), forward.requirements.ids.join(",")]}
		else
      reqs = forward.forwards.where(:status => "FORWARDED").map{|forward| [forward.requirements.where(:employee_id => emp.eid).collect(&:name).join(","), forward.requirements.where(:employee_id => emp.eid).ids.join(",")]}
		end
		reqs = reqs.uniq
		reqs
	end

	def get_open_reqs
	  reqs = Requirement.where(:status => "OPEN").map{ |f| [f.name, f.id ] }
		reqs
	end

  def get_shortlisted_resumes(shortlist)
    emp  = logged_cur_emp
		if emp.employee_type == "HR" || emp.employee_type == "ADMIN"
      reqs = shortlist.req_matches.where(:status => "SHORTLISTED").map{|short| [short.requirement.name, short.requirement.id]}
		else
      reqs = shortlist.req_matches.where(:status => "SHORTLISTED").where("forwarded_to = ?", emp).map{|short| [short.requirement.name, short.requirement.id]}
		end
		reqs = reqs.uniq
		reqs
	end

  def get_holded_resumes(hold)
    emp  = logged_cur_emp
		if emp.employee_type == "HR" || emp.employee_type == "ADMIN"
      reqs = hold.req_matches.where(:status => "HOLD").map{|hold| [hold.requirement.name, hold.requirement.id]}
		else
      reqs = hold.req_matches.where(:status => "HOLD").map{|hold| [hold.requirement.where(:employee_id => emp.eid).name, hold.requirement.where(:employee_id => emp.eid).id]}
		end
		reqs = reqs.uniq
		reqs
	end

  def get_over_all_ratings(values)
	  total              = values.size
		sum                = 0
		values.each do |f|
		  if f.rating      == "Poor"
			  rate           = 1
			elsif f.rating   == "Fair"
			  rate           = 2
			elsif f.rating   == "Good"
			  rate           = 3
			elsif f.rating   == "Very Good"
			  rate           = 4
			elsif f.rating   == "Excellent"
			  rate           = 5
			end
		    sum            += rate
		end
		over_all_rate      = sum/total
		over_all_rate
	end
  
	def get_all_portals_names
	  portals   = Portal.all
		@p_name   = []
		portals.each do |f|
		  @p_name << f.name
		end
		@p_name
	end
  
	def get_all_agencies_names
	  agencies   = Agency.all
		@a_name    = []
		agencies.each do |f|
		  @a_name << f.name
		end
		@a_name
	end

end
