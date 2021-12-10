class EstimatesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_story_and_project
  before_action :find_estimate, only: [:edit, :update, :destroy]

  def new
    @estimate = Estimate.new
  end

  def edit
  end

  def create
    @estimate = @story.estimate_for(current_user) || current_user.estimates.build(story: @story)
    @estimate.attributes = estimate_params

    saved = @estimate.save
    respond_to do |format|
      format.html do
        if saved
          flash[:success] = "Estimate created!"
          redirect_to project_path(@project.id)
        else
          flash[:error] = @estimate.errors.full_messages
          render :new
        end
      end
      format.js
    end
  end

  def update
    updated = @estimate.update(estimate_params)
    respond_to do |format|
      format.html do
        if updated
          flash[:success] = "Estimate updated!"
          redirect_to project_path(@project.id)
        else
          flash[:error] = @estimate.errors.full_messages
          render :edit
        end
      end
      format.js
    end
  end

  def destroy
    @estimate.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: "Estimate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def load_story_and_project
    @project = Project.find(params[:project_id])
    @story = Story.find(params[:story_id])
  end

  def find_estimate
    @estimate = current_user.estimates.where(story_id: params[:story_id]).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Estimate not found"
    redirect_to project_path(params[:project_id])
  end

  def estimate_params
    params.require(:estimate).permit(:best_case_points, :worst_case_points)
  end
end
