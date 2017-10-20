class ResumesController < ApplicationController

  def index
  end

  ############################################################################
  ## Function    : new                                                      ##                                                       
  ## Description : uploading new resume                                     ##                                                       
  ############################################################################

  def new
    @resume       = Resume.new
  end

  def create
    cur_emp                         = get_logged_employee
    @resume                         = Resume.new(resume_authorized_params)
    uniq_id, file_name              = Uniqid.generate_unique_id(@resume.name)
    @resume.file_name               = file_name 
    @resume.experience              = params[:exp][:years] + "-" + params[:exp][:months]
    @resume.uniqid_id               = uniq_id 
    if params[:type] == "EMPLOYEE"
      emp = find_employee(params[:search]) 
      @resume.referral_type = params[:type]
      @resume.referral_id   = emp.eid
    elsif params[:type] == "AGENCY"
      agency = Agency.find_by_name(params[:agency]) 
      @resume.referral_type = params[:type]
      @resume.referral_id   = agency.id
    elsif params[:type] == "PORTAL"
      portal = Portal.find_by_name(params[:portal])
      @resume.referral_type = params[:type]
      @resume.referral_id   = portal.id
    elsif params[:type] == "DIRECT"
      @resume.referral_type = params[:type]
      @resume.referral_id   = 0
    end
    if @resume.save
      flash[:success] = "You have successfully uploaded the resume of \'#{@resume.name}\'."
    else
      log_errors(@resume)
      redirect_to :action => "new"
    end
    comment                         = "UPLOADING: " + cur_emp.name + " uploaded the resume on " + print_date_format(Date.today) + "."
    type                            = "INTERNAL"
    @comment                        = Comment.new
    resume = Resume.find_by_uniqid_id(uniq_id)
    @comment.create_comment(comment, resume.id, cur_emp.eid, type )
    if params[:requirement_name].present?
      params[:requirement_name].each do |f|
        @forwards = Forward.new
        @forwards.create_forwards(cur_emp, resume.id, "FORWARDED", f)
        @comment                    = Comment.new
        req_name                    = Requirement.find(f)
        comment                     = "FORWARDED TO: " + "" + req_name.employee.name + " For " + "" + req_name.name + ". No coments added while forwarding." 
        type                        = "INTERNAL"
        @comment.create_comment(comment, resume.id, cur_emp.eid, type)
        n_forwards                  = resume.nforwards + 1 
        resume.update_columns(:nforwards => n_forwards)
      end
    end
    render "index"
  end

  ############################################################################
  ## Function    : edit                                                     ##                                                       
  ## Description : editing the resume                                       ##                                                       
  ############################################################################

  def edit
    @resume        = Resume.find(params[:id])
  end

  def update
    @resume              = Resume.find(params[:id])
    respond_to do |format|
      if @resume.update(resume_authorized_params)
        flash[:success]  = "You have successfully updated Resume of \'#{@resume.name}\'."
        format.html { redirect_to :action => "index" }
      else
        log_errors(@resume)
        format.html { redirect_to :action => "edit" }
      end
    end
  end

  ############################################################################
  ## Function    : employee_all                                             ##                                              
  ## Description : converting the data into js format for groups            ##                                                       
  ############################################################################

	def employee_all
		respond_to do |format|
		  format.js
		end
	end

	def portals_all
		respond_to do |format|
		  format.js
		end
	end

  def direct
		respond_to do |format|
		  format.js
		end
  end

	def agencies_all
		respond_to do |format|
		  format.js
		end
	end

  def show
    @resume         = Resume.find(params[:id])
    @comments       = @resume.comments
    @feedbacks      = @resume.feedbacks
    @messages       = @resume.messages
		@req_status     = @resume.forwards.where.not(:status => "ACTION TAKEN")
		@req_status     += @resume.req_matches
  end
  
  ############################################################################
  ## Function    : resume_search                                            ##                                                       
  ## Description : searching the resume bases on names                      ##                                                       
  ############################################################################

  def resume_search
    if params[:resume_search].present?
      @resumes         = get_all_resumes  
      cand_name        = params[:resume_search]
      cand_details     = @resumes.where( :name  => cand_name )
      if cand_details.present?
        render "index"
      else
        flash[:danger] = "Name \'#{cand_name}\' could not found in our database."
        redirect_to :action => "index" 
      end
    end
  end

  ############################################################################
  ## Function    : resumes_new                                              ##                                                       
  ## Description : searching the resumes were not forwarded to any req's    ##                                                       
  ############################################################################

  def resumes_new
    #@resumes = Resume.where(:nreq_matches => 0).where(:nforwards => 0).where(:status => "").order("name ASC")
    @resumes = Resume.where(:nreq_matches => 0, :nforwards => 0, :status => "").order("name ASC")
    render "resumes/_resume_show"
  end
  
  ############################################################################
  ## Function    : forwarded                                                ##                                                       
  ## Description : searching the forwarded resumes                          ##                                                       
  ############################################################################

  def forwarded
    status    = "FORWARDED"
    @resumes  = get_matches(status)
    render "resumes/_resume_show"
  end

  ############################################################################
  ## Function    : shortlisted                                              ##                                                       
  ## Description : searching the shortlisted resumes                        ##                                                       
  ############################################################################

	def shortlisted
    status    = "SHORTLISTED"
    @resumes  = get_matches(status)
    render "resumes/_resume_show"
	end

  ############################################################################
  ## Function    : hold                                                     ##                                                       
  ## Description : searching the holded resumes                             ##                                                       
  ############################################################################

	def hold
	  status    = "HOLD"
		@resumes  = get_matches(status)
    render "resumes/_resume_show"
	end

  ############################################################################
  ## Function    : offered_resumes                                          ##                                                       
  ## Description : searching the offered resumes                            ##                                                       
  ############################################################################
	
	def resumes_offered
	  @resumes = ReqMatch.where(:status => "OFFERED")
		render "resumes/offered"
	end

  ############################################################################
  ## Function    : scheduled_interviews                                     ##                                                       
  ## Description : searching the interview scheduled resumes                ##                                                       
  ############################################################################
	
	def scheduled_interviews
	  cur_emp      = get_logged_employee
		if cur_emp.employee_type == "ADMIN" || cur_emp.employee_type == "HR"
	    @interviews = ReqMatch.where(:status => "SCHEDULED")
		else
	    #@interviews = ReqMatch.where("forwarded_to = ?", cur_emp.eid).where(:status => "SCHEDULED")
	    @interviews = ReqMatch.where("forwarded_to = ?", cur_emp.eid, :status => "SCHEDULED")
		end
		render "resumes/interviews_status"
	end

  ############################################################################
  ## Function    : resumes_joining                                          ##                                                       
  ## Description : searching the joining resumes                            ##                                                       
  ############################################################################
	
  def resumes_joining
	  @resumes = ReqMatch.where(:status => "JOINING")
		render "resumes/joining"
	end

  ############################################################################
  ## Function    : resumes_rejected                                         ##                                                       
  ## Description : searching the rejected resumes                           ##                                                       
  ############################################################################
	
  def resumes_rejected
	  @resumes = Resume.where(:overall_status => "REJECTED")
		render "resumes/_resume_show"
	end

  ############################################################################
  ## Function    : resumes_future                                           ##                                                       
  ## Description : searching the future resumes                             ##                                                       
  ############################################################################
	
  def resumes_future
	  @resumes = Resume.where("status = ? OR status = ?", "FUTURE", "N_ACCEPTED")
		render "resumes/_resume_show"
	end

  def get_matches(status)
		cur_emp    = get_logged_employee 
    resumes    = []
		if status == "FORWARDED"
		  if cur_emp.employee_type == "HR" 
        forwarded = Forward.where("forwarded_by = ?", cur_emp).where(:status => status)
        forwarded.each do |f|
          resumes << Resume.find(f.resume_id)
        end
			elsif cur_emp.employee_type == "ADMIN"
        forwarded = Forward.where("forwarded_to = ?", cur_emp).where(:status => status)
        forwarded.each do |f|
          resumes << Resume.find(f.resume_id)
        end
		  else
        forwarded = Forward.where("forwarded_to = ?", cur_emp).where(:status => status)
        forwarded.each do |f|
          resumes << Resume.find(f.resume_id)
        end
		  end
		elsif status == "SHORTLISTED"
		  if cur_emp.employee_type == "HR" || cur_emp.employee_type == "ADMIN"
        shortlisted = ReqMatch.where(:status => status) 
        shortlisted.each do |f|
          resumes << Resume.find(f.resume_id)
		    end
		  else
        shortlisted = ReqMatch.where(:status => status).where("forwarded_to = ?", cur_emp)
        shortlisted.each do |f|
          resumes << Resume.find(f.resume_id)
		    end
		  end
		elsif status == "HOLD"
      hold       = ReqMatch.where(:status => status)
      hold.each do |f|
        resumes << Resume.find(f.resume_id)
		  end
    end
    uniq_data = uniq_by(resumes)
    uniq_data
  end

  def uniq_by(g_data)
    g_data.uniq 
  end

  ############################################################################
  ## Function    : my_interviews                                            ##                                              
  ## Description : searching the scheduled interviews for login employee    ##                                                       
  ############################################################################
  
	def my_interviews
    @interviews          = get_logged_employee.interviews.joins(:req_match).where("req_matches.status = ?", "SCHEDULED")
		render "resumes/interview_requests"
	end

  ############################################################################
  ## Function    : my_resumes                                               ##                                              
  ## Description : searching the resumes referred by login employee         ##                                                       
  ############################################################################
  
	def my_resumes
		logged_emp      = get_logged_employee
		if logged_emp.employee_type == "HR"
		  @resumes        = Resume.where(:nforwards => 0, :employee_id => logged_emp.eid) 
		else
		  @resumes        = Resume.where(:referral_type => "EMPLOYEE", :referral_id => logged_emp.eid) 
		  #@resumes        = Resume.where(:referral_type => "EMPLOYEE").where(:referral_id => logged_emp.eid) 
		end
    render "resumes/_resume_show"
	end

	def decline_resume
    @interview     = Interview.find(params[:id])
		@int_id        = @interview.id.to_s
		@resume_id     = params[:resume_id]
		@req_id        = params[:req_id]
		respond_to do |format|
		  format.js
		end
	end

	def decline_interview
	  cur_emp               = get_logged_employee
		interview             = Interview.find(params[:id])
		requirement           = Requirement.find(params[:req_id])
		interview.update_columns(:status => "DECLINED")
		@comment              = Comment.new
		comment               = "INTERVIEW DECLINED BY: " + cur_emp.name + " " + params[:comment] + " for " + requirement.name
		resume_id             = params[:resume_id]
		ctype                 = params[:type]
		@comment.create_comment( comment, resume_id, cur_emp.eid, ctype )
	end
	
	def feedbacks
		@int_id        = params[:id].to_s
		@resume_id     = params[:resume_id]
		respond_to do |format|
		  format.js
		end
	end

  def create_feedback
	  cur_emp               = get_logged_employee
	  @feedback             = Feedback.new
		@feedback.resume_id   = params[:resume_id]
		@feedback.employee_id = cur_emp.eid
		@feedback.rating      = params[:rating]
		@feedback.feedback    = params[:comment]
		@feedback.save
	end

  ############################################################################
  ## Function    : move_to_future                                           ##                                              
  ## Description : changing the status of resumes                           ##                                                       
  ############################################################################
	
	def move_to_future
	  status         = params[:r_status]
    resume         = Resume.find(params[:res])
    resume.update_columns(:status => status)
		if status.present?
		  if status    == "FUTURE"
        flash[:success] = "You have successfully moved the resume \'#{resume.name}'\ to future."
		  elsif status == "REJECTED"
        flash[:success] = "You have successfully Rejected the resume \'#{resume.name}'\."
			elsif status == ""
        flash[:success] = "You have successfully marked the resume \'#{resume.name}'\ as active."
			end
		end
	end

	def reject_resume
	  @resume = params[:id]
		@res_id = @resume.to_s
		respond_to do |format|
		  format.js
		end
	end

	def resume_status_to_rejected
	  cur_emp               = get_logged_employee
    resume                = Resume.find(params[:id])
    resume.update_columns(:status => params[:status])
		@comment              = Comment.new
		comment               = "REJECTED: " + params[:comment] 
		ctype                 = params[:type]
		@comment.create_comment( comment, resume.id, cur_emp.eid, ctype )
	end

  ############################################################################
  ## Function    : mark_as_joining                                          ##                                              
  ## Description : Adding the joining date for resume                       ##                                                       
  ############################################################################
	
	def mark_as_joining
	  date              = params[:date]
		resume            = Resume.find(params[:id])
		if date.present?
      resume.update_columns(:joining_date => date)
      flash[:success] = "You have successfully updated the joining date \'#{resume.name}'\."
		end
		render 'index'
	end

  ############################################################################
  ## Function    : show_resume_comments                                     ##                                              
  ## Description : converting the data into js format for comments          ##                                                       
  ############################################################################
	
	def show_resumes_comments
    @resume = params[:id] #Resume.find(params[:id])
		@res_id = @resume.to_s
		respond_to do |format|
		  format.js
		end
	end

  ############################################################################
  ## Function    : comments_new                                             ##                                              
  ## Description : adding a new comment for a resume                        ##                                                       
  ############################################################################

	def comment_new
	  cur_emp               = get_logged_employee
		@comment              = Comment.new
		if params[:comment].present?
		  comment    =  "COMMENTED: " + "" + params[:comment] + "."
		end
		if params[:type].present?
		  ctype        = params[:type]
		else
	  	ctype        = "INTERNAL"
		end
		if params[:id].present?
		  resume_id    = params[:id]
		end
		@comment.create_comment( comment, resume_id, cur_emp.eid, ctype )
    if ctype == "USER"
      respond_to do |format|
        format.html 
  	  end
    end
  end

  ############################################################################
  ## Function    : show_reqs                                                ##                                              
  ## Description : converting the data into js format for requirements      ##                                                       
  ############################################################################

	def show_reqs
		@res_id        = params[:id]
		@res_id.to_s
		@requirements  = Requirement.where(:status => "OPEN" )
		respond_to do |format|
		  format.js
		end
	end

  ############################################################################
  ## Function    : hr_forwards                                              ##                                              
  ## Description : changing the status of resume to 'FORWARDED' and add the ##
	##               related comment in comments model                        ##
  ############################################################################

	def hr_forwards
	  params[:req_status].each do |f|
	    cur_emp                    = get_logged_employee
		  @forwards                  = Forward.new
			@forwards.create_forwards( cur_emp, params[:r_id], "FORWARDED", f )
		  @comment                   = Comment.new
			req_name                   = Requirement.find(f)
			comment                    = "FORWARDED TO: " + "" + req_name.employee.name + " For " + "" + req_name.name + ". No coments added while forwarding." 
		  resume_id                  = params[:r_id]
		  type                       = "INTERNAL"
		  @comment.create_comment(comment, resume_id, cur_emp.eid, type)
	  end
    respond_to do |format|
      flash[:success]            = "successfully forwarded the resume."
	  	resume                       = Resume.find(params[:r_id])
		  n_forwards                   = resume.nforwards + 1 #params[:req_status].size
	    resume.update_columns(:nforwards => n_forwards)
		end
	end

  ##############################################################################
  ## Function    : manager_shortlists                                         ##                                              
  ## Description : converting the data into js format for shortlisted resumes ##                                                       
  ##############################################################################
	
	def manager_shortlists
    @req_ids       = params[:req_id]
		@status        = params[:r_status]
	  @resume        = params[:resume] #Resume.find(params[:resume])
		@res_id        = @resume.id.to_s
		respond_to do |format|
		  format.js
		end
	end
  
  ############################################################################
  ## Function    : req_match_new                                            ##                                              
  ## Description : changing the status of resume to 'ACTION TAKEN' and add  ##
	##               the related comment in comments table, create req_match  ##
	##               with status is 'SHORTLISTED'                             ##
  ############################################################################

	def req_match_new
	  cur_emp                         = get_logged_employee
		status                          = params[:status]
	  req_ids                         = params[:req_id].split(",")
	  resume                          = Resume.find(params[:resume_id])
    req_ids.each do |f|
		  requirement                   = Requirement.find(f)
			requirement.forwards.where(:resume_id => resume.id).update(:status => "ACTION TAKEN")
		  req_match                     = ReqMatch.new
		  req_match.resume_id           = resume.id
		  req_match.requirement_id      = requirement.id 
		  req_match.forwarded_to        = Employee.find(requirement.employee_id)
      req_match.status              = status
		  req_match.save
			type                          = params[:type]
			text                          = params[:comment]                
			comment                       = status + " :" + text + " For " + "" + requirement.name + "."
			@comment                      = Comment.new
			@comment.create_comment(comment, resume.id, cur_emp.eid, type )
			if status                     == "SHORTLISTED"
		    nreq_matches                = resume.nreq_matches + 1
	      resume.update_columns(:nreq_matches => nreq_matches)
			end
		end
	end

  def interview_add
    @req_ids       = params[:req_id]
		@r_status      = params[:r_status].to_s
		@i_status      = params[:i_status].to_s
	  @resume        = params[:resume]
		@res_id        = @resume.to_s
		respond_to do |format|
		  format.js
		end
	end

	def create_new_interview
		req_ids                             = params[:req_id].split(",")
		emp                                 = find_employee(params[:emp_name])
		req_ids.each do |f|
		  requirement                       = Requirement.find(f)
      date                              = params[:i_date].to_date.strftime('%Y-%d-%b')
	    time                              = params[:i_date].to_time.strftime("%H:%M:%S")
		  #req_match                         = ReqMatch.where(:resume_id => params[:resume_id]).where(:requirement_id => f)
		  req_match                         = ReqMatch.where(:resume_id => params[:resume_id], :requirement_id => f)
		  interview                         = Interview.new
	    interview.focus                   = params[:focus] 
	    interview.stage                   = params[:i_stage] 
	    interview.itype                   = params[:i_type] 
	    interview.interview_date          = date.to_date  
	    interview.interview_time          = time.to_time 
	    interview.employee_id             = emp.eid  
	    interview.status                  = "NEW"   
		  interview.req_match_id            = req_match.ids[0]
		  interview.save
			req_match.update_all(:status => params[:r_status])
			comment                           = "ADDING INTERVIEWS FOR: " + "" + emp.name + " for requirement " + requirement.name
			type                              = "INTERNAL"
			resume_id                         = params[:resume_id]
			emp_id                            = emp.eid
			@comment                          = Comment.new
			@comment.create_comment(comment, resume_id, emp_id, type )
		end
	end

  ##############################################################################
  ## Function    : manager_holds                                              ##                                              
  ## Description : converting the data into js format for HOLD the resumes    ##
	##               from shortlisted resumes                                   ##                                                       
  ##############################################################################
	
	def manager_holds
    @req_ids       = params[:req_id]
		@status        = params[:r_status].to_s
	  @resume        = params[:resume] 
		@res_id        = @resume.to_s
		if @status == "SHORTLISTED"
		  respond_to do |format|
		    format.js { render "manager_shortlists.js.erb"}
		  end
		elsif @status != "JOINING"
		  respond_to do |format|
		    format.js
		  end
		elsif @status == "JOINING"
		  @joindate    = params[:jdate]
		  respond_to do |format|
		    format.js { render "offer.js.erb" }
		  end
		end
	end

	def manager_offer
    @req_ids       = params[:req_id]
		@status        = params[:r_status].to_s
	  @resume        = params[:resume] 
		@res_id        = @resume.to_s
		if @status     == "OFFERED"
		  respond_to do |format|
		    format.js #{ render "manager_offer.js.erb" }
		  end
    elsif @status == "JOINING"
		  raise "JOIN".inspect
		end
	end

	def manager_joining
	  raise params[:action].inspect
	  cur_emp                         = get_logged_employee
		status                          = params[:status]
	  req_ids                         = params[:req_id].split(",")
	  resume                          = Resume.find(params[:resume_id])
    req_ids.each do |f|
		  requirement                   = Requirement.find(f)
			requirement.forwards.where(:resume_id => resume.id).update(:status => "ACTION TAKEN")
		  req_match                     = ReqMatch.new
		  req_match.resume_id           = resume.id
		  req_match.requirement_id      = requirement.id 
		  req_match.forwarded_to        = Employee.find(requirement.employee_id)
      req_match.status              = status
		  req_match.save
			type                          = params[:type]
			text                          = params[:comment]                
			comment                       = status + " :" + text + " For " + "" + requirement.name + "."
			@comment                      = Comment.new
			@comment.create_comment(comment, resume.id, cur_emp.eid, type )
			end
	end

  ##############################################################################
  ## Function    : manager_forward_hold                                       ##                                              
  ## Description : converting the data into js format for HOLD the resumes    ##
	##               from forwarded resumes                                     ##                                                       
  ##############################################################################
	
	def manager_forward_hold
    @req_ids       = params[:req_id]
		@status        = params[:r_status]
	  @resume        = params[:resume] 
		@res_id        = @resume.to_s
		respond_to do |format|
		  format.js
		end
	end

  ############################################################################
  ## Function    : req_match_hold                                           ##                                              
  ## Description : changing the status of resume to 'HOLD' and in req_match ##
	##               the related comment in comments table.                   ##
  ############################################################################

	def req_match_hold
	  cur_emp                         = get_logged_employee
	  req_ids                         = params[:req_id].split(",")
		status                          = params[:status]
		resume                          = params[:resume_id]
		if params[:jdate].present?
	    resume                        = Resume.find(params[:resume_id])
		  resume.update(:joining_date => params[:jdate] )
		end
    req_ids.each do |f|
		  requirement                   = Requirement.find(f)
			requirement.forwards.where(:resume_id => resume).update(:status => "ACTION TAKEN")
		  #req_match                     = ReqMatch.where(:resume_id => resume).where(:requirement_id => requirement.id)
		  req_match                     = ReqMatch.where(:resume_id => resume, :requirement_id => requirement.id)
	    req_match.update_all(:status => status)
			type                          = params[:type]
			text                          = params[:comment]                
			comment                       = status + " : " + text + " For " + "" + requirement.name + "."
			@comment                      = Comment.new
			@comment.create_comment(comment, resume, cur_emp.eid, type )
		end
	end

  ############################################################################
  ## Function    : show_message                                             ##                                              
  ## Description : converting the data into js format for messages          ##                                                       
  ############################################################################

	def show_message
	  if params[:id].present?
      @resume         = params[:id]
		  @res_id         = @resume.to_s
		elsif params[:mes_id].present?
      @resume         = params[:resume_id] 
		  @res_id         = params[:mes_id].to_s
		  @message_id     = params[:mes_id]
		end
		respond_to do |format|
		  format.js
		end
	end

  ############################################################################
  ## Function    : message_new                                              ##                                              
  ## Description : adding a new message for a resume                        ##                                                       
  ############################################################################

  def message_new
    @employees                = get_all_employees
	  emp_details               = find_employee(params[:emp_name])
	  @message                  = Message.new
	  @message.resume_id        = params[:id]
	  @message.sent_to          = emp_details
	  @message.sent_by          = get_logged_employee
	  @message.message          = params[:message]
    respond_to do |format|
      if @message.save
        flash[:success]       = "successfully sent the message to \'#{params[:emp_name]}\'."
	    else
        flash[:danger]        = "unable to delivery the message."
	    end
	  end
  end

  ############################################################################
  ## Function    : inbox                                                    ##                                              
  ## Description : getting the all messages for login employee              ##                                                       
  ############################################################################

  def inbox
    cur_emp     = get_logged_employee
    @messages   = Message.where("sent_to = ?", cur_emp).where(:is_deleted => nil )
    render "resumes/message_show"
  end

  ############################################################################
  ## Function    : outbox                                                   ##                                              
  ## Description : getting the all messages sent by login employee          ##                                                       
  ############################################################################

  def outbox
    cur_emp     = get_logged_employee
    @messages   = Message.where("sent_by = ?", cur_emp).where(:is_deleted => nil) 
    render "resumes/message_show"
  end

  ############################################################################
  ## Function    : trash                                                    ##                                              
  ## Description : getting the all the deleted messages login employee      ##                                                       
  ############################################################################

  def trash
    cur_emp     = get_logged_employee
    @messages   = Message.where("sent_to = ?", cur_emp).where("is_deleted = ?", 1 )
    render "resumes/message_show"
  end

  ############################################################################
  ## Function    : message_delete                                           ##                                              
  ## Description : deleting message for a resume by login employee          ##                                                       
  ############################################################################

  def message_delete
    messages              = params[:mesg_ids]
    if messages.present?
      messages.each do |f|
        mesg              = Message.find(f)
        mesg.update_columns(:is_deleted => 1 )
        flash[:success]   = "You have successfully Deleted the Message"
      end
    else
      flash[:danger]      = "Please select checkbox to DELETE the messages"
    end
    redirect_to :back
  end

  private
  def resume_authorized_params
    params.require(:resume).permit( :name, :phone, :email, :experience, :ctc, :notice, :current_company, :location, :skype_id, :expected_ctc, :qualification, :summary, :file )
  end

end
