class RequirementsController < ApplicationController

  def index
    @requirements = Requirement.where(:status => "OPEN").order("edate ASC")
  end

  def all
    @requirements = Requirement.all
    render 'index'
  end

  ############################################################################
  ## Function    : update_to                                                ##                                                       
  ## Description : Changing the status of requirement from open to close    ##                                                       
  ############################################################################
  
  def update_to
    req_id1 = params[:req_status] 
		if req_id1.present?  
      req_id1.each do |id|
        old = Requirement.find( id )
        old.update_columns(:status => "CLOSED EXPIRED")
        flash[:success] = "You have successfully closed the requirement"
      end
    else
      flash[:danger] = "Please select checkbox to INACTIVE requirements."
    end
      redirect_to :back
  end

  def my_requirements
		@requirements = get_logged_employee.requirements.where(:status => "OPEN")
		render "index"
	end

  def closed
  	@requirements = Requirement.where.not(:status => "OPEN").order("edate ASC")
    render 'index'
  end
  
  ############################################################################
  ## Function    : search                                                   ##                                                       
  ## Description : find all the requirements belongs to the employee        ##                                                       
  ############################################################################
  
  def search
    if params[:search].present?
      emp_details = find_employee(params[:search]) 
      if emp_details.present?
        @requirements = Requirement.where(employee_id: emp_details.eid, status: "OPEN")            
        render "index"
      else
        flash[:danger] = "Employee \'#{params[:search]}\' is not exists."
        redirect_to :action => "index" 
      end
    end
  end

  ############################################################################
  ## Function    : new                                                      ##                                                       
  ## Description : creating new requirement                                 ##                                                       
  ############################################################################
  
  def new
    @employees = get_all_employees
    @designations = get_all_desigantions
    @accounts = get_all_accounts
    @groups = get_all_groups
    @requirement = Requirement.new
  end

  def create
    @requirement = Requirement.new(requirement_authorized_params)
    @requirement.sdate = change_date_format(@requirement.sdate)
    @requirement.edate = change_date_format(@requirement.edate)
    @requirement.exp = params[:req][:min_exp] + "-" + params[:req][:max_exp]
    respond_to do |format|
      if @requirement.save
        flash[:success] = "You have successfully created requirement \'#{@requirement.name}\'."
        format.html {redirect_to :action => "index"}
      else
    		log_errors(@requirement)
        format.html { redirect_to :action => "new"}
      end
    end
  end
  
  ############################################################################
  ## Function    : edit                                                     ##                                                       
  ## Description : editing the requirement based on 'id'                    ##                                                       
  ############################################################################

  def edit
    @employees = get_all_employees
    @designations = get_all_desigantions
    @accounts = get_all_accounts
    @groups = get_all_groups
    @requirement = Requirement.find(params[:id])
  end

  def update
    @requirement = Requirement.find(params[:id])
    @requirement.exp = params[:req][:min_exp] + "-" + params[:req][:max_exp]
    respond_to do |format|
      if @requirement.update(requirement_authorized_params)
        flash[:success] = "You have successfully updated requirement \'#{@requirement.name}\'."
        format.html { redirect_to :action => "index" }
      else
	      log_errors(@requirement)
        format.html { redirect_to :action => "edit" }
      end
    end
  end

  ############################################################################
  ## Function    : destroy                                                  ##                                                       
  ## Description : deleting the requirement based on 'id'                   ##                                                       
  ############################################################################

  def destroy
    requirement = Requirement.find(params[:id])
    message = "Successfully Deleted the Requirement \'#{requirement.name}\'."
    requirement.destroy
    flash[:danger] = message
    redirect_to :action => "index"
  end

  ############################################################################
  ## Function    : show                                                     ##                                                       
  ## Description : show the requirement description bases on 'id'           ##                                                       
  ############################################################################
  
	def show
    @requirement      = Requirement.find(params[:id])
    @forwards         = @requirement.forwards.where(:status => "FORWARDED")    
		req_match         = ReqMatch.where(:requirement_id => @requirement.id)
    @shortlisted      = req_match.where(:status => "SHORTLISTED")
    @hold             = req_match.where(:status => "HOLD")
    @offered          = req_match.where(:status => "OFFERED")
    @joining          = req_match.where(:status => "JOINING")
    @rejected         = req_match.where(:status => "REJECTED")
    @scheduled        = req_match.where(:status => "SCHEDULED")
  end

  #################################################################################################################
  ## Function    : req_analysis                                                                                  ##                         
  ## Description : Analyze the Number of open and closed positions of requirements in the span of 6 months       ##                                   
  #################################################################################################################

  def req_analysis 
    # start month. Default is current otherwise get it from params.
    # start year.  Default is current otherwise get it from params.
    # end month.   Default is current otherwise get it from params.
    # end year.    Default is current otherwise get it from params.
    # next = start month + 6
    # prev = start month - 6

    @test       = 0
    db          = ( 11 + @test ).downto( -6 + @test )
    new         = all_months(db) 
    @groups     = get_all_groups
    array       = []
    if( params[:sample] == "current")
      @test     = 0
      db        = ( 11 + @test ).downto( -6 + @test )
      new       = all_months(db) 
      (6..11).each do |f|
        array << new[f].to_date.at_beginning_of_month 
      end
      @req_analysis_data = req_analysis_nop(array, @groups) 
    elsif(params[:sample] == "next")
      @test     = params[:val].to_i
      db        = ( 11 + @test ).downto( -6 + @test )
      new       = all_months(db) 
      (12..17).each do |f|
        array << new[f].to_date.at_beginning_of_month 
      end
      @req_analysis_data = req_analysis_nop(array, @groups) 
    elsif(params[:sample] == "previous")
      @test     = params[:val].to_i
      db        = ( 11 + @test ).downto( -6 + @test )
      new       = all_months(db) 
      (0..5).each do |f|
        array << new[f].to_date.at_beginning_of_month 
      end
      @req_analysis_data = req_analysis_nop(array, @groups) 
    else
      @test       = params[:val].to_i
      (6..11).each do |f|
        array << new[f].to_date.at_beginning_of_month 
      end
      @req_analysis_data = req_analysis_nop(array, @groups) 
    end
    @current_m  = new[6].to_date.strftime("%b, %y") .. new[11].to_date.strftime("%b, %y")
    @previous_m = new[0].to_date.strftime("%b, %y") .. new[5].to_date.strftime("%b, %y")
    @next_m     = new[12].to_date.strftime("%b, %y") .. new[17].to_date.strftime("%b, %y") 
    current1_m = Date.today
    prev1_m    = current1_m - 6.months
    next1_m    = current1_m + 6.months
    all = all_months_in_test(current1_m)
    logger.info(all)
    render "requirements/_req_analysis"
  end
  
  def testing
    @groups1             = get_all_groups
    @current_m           = Date.today
    @prev_m              = @current_m - 6.months
    @next_m              = @current_m + 6.months
    all                  = all_months_in_test(@current_m)
    @req_analysis_data   = req_analysis_nop(all, @groups1) 

    if( params[:sample] == "previous")
      @next_m            = @current_m 
      @current_m         = @current_m - 6.months
      @prev_m            = @current_m - 6.months 
      all                = all_months_in_test(@prev_m)
      @req_analysis_data = req_analysis_nop(all, @groups1) 
    end

    if( params[:sample] == "next")
      @prev_m            = @current_m 
      @current_m         = @current_m + 6.months
      @next_m            = @current_m + 6.months
      all                = all_months_in_test_plus(@next_m)
      @req_analysis_data = req_analysis_nop(all, @groups1) 
    end

    if( params[:sample] == "current")
      @current_m         = @current_m
      @prev_m            = @current_m - 6.months
      @next_m            = @current_m + 6.months
      all                = all_months_in_test(@current_m)
      @req_analysis_data = req_analysis_nop(all, @groups1) 
    end

    render "requirements/_req_analysis"
  end
  
  private
  def requirement_authorized_params
    params.require(:requirement).permit( :name, :employee_id, :nop, :designation_id, :description, :skill, :sdate, :edate, :mgt_comment, :group_id, :account_id, :schedule_owner, :source_owner, :status, :posting_emp_id, :req_type, :exp )
  end
  
end
