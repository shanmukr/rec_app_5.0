class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end 

  def new
    @employees = get_all_employees
    @group = Group.new
  end 
        
  def create
    @group = Group.new(group_authorized_params)
    respond_to do |format|
      if @group.save
        flash[:success] = "You have successfully created Group \'#{@group.name}\'."
        format.html { redirect_to :action => "index" }
      else
        log_errors(@group)
        format.html { redirect_to :action => "new" }
      end
    end
  end 
             
  def edit
    @employees = get_all_employees
    @group = Group.find(params[:id])
  end 
                      
  def update
    @group = Group.find(params[:id])
    respond_to do |format|
      if @group.update(group_authorized_params)
        flash[:success] = "You have successfully updated Group \'#{@group.name}\'."
        format.html { redirect_to :action => "index" }
      else
        log_errors(@group)
        format.html { redirect_to :action => "edit" }
      end
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def destroy
    group = Group.find(params[:id])
    message = "Successfully deleted Group \'#{group.name}\'."
    group.destroy
    flash[:danger] = message
    redirect_to :action => "index"
  end

  def group_authorized_params
    params.require(:group).permit(:name, :employee_id)
  end
end
