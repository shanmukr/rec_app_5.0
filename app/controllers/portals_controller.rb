class PortalsController < ApplicationController
  def index
    @portals = Portal.all
  end 

  def new
    @portal = Portal.new
  end 

  def create
    @portal = Portal.new(portal_authorized_params)
    respond_to do |format|
      if @portal.save
        flash[:success] = "You have successfully created portal \'#{@portal.name}\'"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@portal)
        format.html { redirect_to :action => "new" }
      end
    end
  end 

  def edit
    @portal = Portal.find(params[:id])
  end 

  def update
    @portal = Portal.find(params[:id])
    respond_to do |format|
      if @portal.update(portal_authorized_params)
        flash[:success] = "You have successfully updated portal \'#{@portal.name}\'."
        format.html { redirect_to :action => "index" }
      else
        log_errors(@portal)
        format.html { redirect_to :action => "edit" }
      end
    end
  end 
  
  def destroy
    portal = Portal.find(params[:id])
    message = "Succesfully deleted portal \'#{portal.name}\'."
    portal.destroy
    flash[:danger] = message
    redirect_to :action => "index"
  end

  private
  def portal_authorized_params
    params.require(:portal).permit(:name)
  end
end
