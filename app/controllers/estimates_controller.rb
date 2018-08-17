class EstimatesController < ApplicationController

  before_action :load_story_and_project

  def new
    @estimate = Estimate.new
  end

  def edit
    @estimate = Estimate.find(params[:id])
  end

  def create
    params["estimate"]["user_id"] = current_user.id
    @estimate = Estimate.new(estimate_params)

    if @estimate.save
      flash[:success] = "Estimate created!"
      redirect_to project_path(@project.id)
    else
      flash[:error] = @estimate.errors.full_messages
      render :new
    end
  end

  def update
    @estimate = Estimate.find(params[:id])
    params["estimate"]["user_id"] = current_user.id

    if @estimate.update_attributes(estimate_params)
      flash[:success] = "Estimate updated!"
      redirect_to project_path(@project.id)
    else
      flash[:error] = @estimate.errors.full_messages
      render :edit
    end
  end

  def destroy
    @estimate.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Estimate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def load_story_and_project
      @project = Project.find(params[:project_id])
      @story = Story.find(params[:story_id])
    end

    def estimate_params
      params.require(:estimate).permit(:best_case_points, :worst_case_points, :user_id, :story_id)
    end
end
