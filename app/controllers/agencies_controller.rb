class AgenciesController < ApplicationController
  # before_filter :check_for_login
  # before_filter :check_for_HR_or_ADMIN

  def index
    @agencies = Agency.all
  end

  def new
    @agency = Agency.new
  end

  def create
    @agency = Agency.new(agency_authorized_params)
    respond_to do |format|
      if @agency.save
        flash[:success] = "Successfully added agency \'#{@agency.name}\'."
        format.html { redirect_to :action => "index" }
      else
        log_errors(@agency)
        format.html { redirect_to :action => "new" }
      end
    end
  end

  def edit
    @agency = Agency.find(params[:id])
  end

  def update
    @agency = Agency.find(params[:id])
    respond_to do |format|
      if @agency.update(agency_authorized_params)
        flash[:success] = "You have successfully updated agency \'#{@agency.name}\'"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@agency)
        format.html { redirect_to :action => "edit" }
      end
    end
  end

  def destroy
    agency = Agency.find(params[:id])
    message = "Succesfully deleted agency \'#{agency.name}\'."
    agency.destroy
    flash[:danger] = message
    redirect_to :action => "index"
  end

  private
  def agency_authorized_params
    params.require(:agency).permit(:name)
  end
end
