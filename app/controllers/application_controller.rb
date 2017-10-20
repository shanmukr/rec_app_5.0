class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
 
  def set_logged_emp(cur_emp)
    session[:logged_emp] = cur_emp
  end

  def get_logged_employee
    if session[:logged_emp].present?
      session[:cur_employee] = Employee.find_by( login: session[:logged_emp] )     
      @cur_employee = session[:cur_employee]
    end
  end

  def req_analysis_nop(months, groups)
    @months    = months
    s = @months[0]
    s = s.to_date.at_beginning_of_month
    all_reqs = Requirement.all
    hash = Hash.new
    groups.each do |g|
      req_data = Hash.new
      req_data["Open"] = {}
      req_data["Close"] = {}
      all_reqs = g.requirements
      if ( all_reqs.where( :status => "OPEN" ).where( "sdate <= ?", s ).sum(:nop) <= all_reqs.where.not( :status => "OPEN" ).where( "sdate <= ?", s ).sum(:nop) )
        count = 0
      else
        count = all_reqs.where( :status => "OPEN" ).where( "sdate <= ?", s ).sum(:nop) - all_reqs.where.not(status: "OPEN").where( "sdate <= ?", s ).sum(:nop)
      end
      @months.each do |m|
        m = m.to_date  
        req_data["Open"][m.strftime("%B, %Y")]  = all_reqs.where( :status => "OPEN", :sdate => (m.beginning_of_month .. m.at_end_of_month)).sum(:nop) + count
        req_data["Close"][m.strftime("%B, %Y")] = all_reqs.where.not(status: "OPEN").where( :edate => (m.beginning_of_month .. m.at_end_of_month)).sum(:nop) 
        if ( req_data["Open"][m.strftime("%B, %Y")] <= req_data["Close"][m.strftime("%B, %Y")])
          count    = 0
        else
          count = req_data["Open"][m.strftime("%B, %Y")] - req_data["Close"][m.strftime("%B, %Y")]
        end
      end
      hash[g.name] = req_data
    end
    hash
  end
  
  def all_months(number_of_months)
    array = number_of_months  
    @all_months = []  
    ( array ).each do |a|
      month = Date.today - a.months
      @all_months << change_date_format(month.at_beginning_of_month)
    end
    @all_months
  end

  def all_months_in_test(number_of_months)
    array = number_of_months
    array = array.to_date  
    @all_months1 = []  
    ( -5 .. 0 ).each do |a|
      month = array + a.months
      @all_months1 << change_date_format(month.at_beginning_of_month)
    end
    @all_months1
  end

  def all_months_in_test_plus(number_of_months)
    array = number_of_months
    array = array.to_date  
    @all_months1 = []  
    ( 0 .. 5).each do |a|
      month = array + a.months
      @all_months1 << change_date_format(month.at_beginning_of_month)
    end
    @all_months1
  end
  
  def change_date_format(date)
    date.strftime("%Y-%m-%d")
  end
  
	def print_date_format(date)
    date.strftime("%b %d, %Y")
  end

  def get_all_resumes
    Resume.all
  end
  
  def get_all_employees
    Employee.all
  end
 
  def find_employee(emp_name)
	  employees      = get_all_employees
    emp_details    = employees.find_by("login = ? OR name = ?", emp_name, emp_name )
	end

  def get_all_desigantions
    Designation.all
  end
  
  def get_all_groups
    Group.all
  end
  
  def get_all_accounts
    Account.all
  end

  def get_month_year
    @month          = Date.today.month 
    @year           = Date.today.year 
    [ @month, @year ]
  end
  
  def change_date_format(date)
    if date.present?
      date.strftime("%Y-%m-%d")
    else
      flash[:danger] = "Please select the date."
    end
  end

  def log_errors(object)
    unless object.valid?
      object.errors.full_messages.each { |mesg|
        logger.info(mesg)
        if flash[:danger].nil? 
          flash[:danger] = mesg
        else
          flash[:danger] = flash[:danger] + ", " + mesg 
        end
      }
    end
  end
end
