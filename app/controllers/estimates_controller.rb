class EstimatesController < ApplicationController

  def index
    @estimates = Estimate.all
  end

  def show
  end

  def new
    @estimate = Estimate.new
  end

  def edit
    @project = Project.find(params[:project_id])
    @story = Story.find(params[:story_id])
    @estimate = Estimate.find(params[:id])
  end

  def create
    @estimate = Estimate.new(estimate_params)

    respond_to do |format|
      if @estimate.save
        format.html { redirect_to @estimate, notice: 'Estimate was successfully created.' }
        format.json { render :show, status: :created, location: @estimate }
      else
        format.html { render :new }
        format.json { render json: @estimate.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @estimate = Estimate.find(params[:id])
    params["estimate"]["user_id"] = current_user.id

    @project = Project.find(params[:project_id])
    debugger
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
      format.html { redirect_to estimates_url, notice: 'Estimate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    def estimate_params
      params.require(:estimate).permit(:best_case_points, :worst_case_points, :user_id, :story_id)
    end
end
