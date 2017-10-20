class DesignationsController < ApplicationController
  def index
    @designations = Designation.all
  end

  def new
    @designation = Designation.new
  end

  def create
    @designation = Designation.new(designation_authorized_params)
    respond_to do |format|
      if @designation.save
        flash[:success] = "You have successfully created Designation \'#{@designation.name}\'."
        format.html { redirect_to :action => "index" }
      else
        log_errors(@designation)
        format.html { redirect_to :action => "new" }
      end
    end 
  end

  def edit
    @designation = Designation.find(params[:id])
  end 

  def update
    @designation = Designation.find(params[:id])
    respond_to do |format|
      if @designation.update(designation_authorized_params)
        flash[:success] = "You have successfully updated Designation \'#{@designation.name}\'."
        format.html { redirect_to :action => "index" }
      else
        log_errors(@designation)
        format.html { redirect_to :action => "edit" }
      end
    end 
  end 
  
  def destroy
    designation = Designation.find(params[:id])
    message = "Successfully Deleted Designation \'#{designation.name}\'."
    designation.destroy
    flash[:danger] = message
    redirect_to :action => "index"
  end

  private
  def designation_authorized_params
    params.require(:designation).permit(:name)
  end
end
