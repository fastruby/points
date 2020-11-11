require 'csv'
class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, except: :bulk_destroy
  before_action :find_story, only: [:edit, :update, :destroy, :show]

  CSV_HEADERS = %w{id title description position}

  def new
    @story = Story.where(id: params[:story_id]).first_or_initialize.dup
  end

  def edit
  end

  def create
    @story = Story.new(stories_params)
    @story.project_id = @project.id

    if @story.save
      flash[:success] = "Story created!"
      redirect_to project_path(@project.id)
    else
      flash[:error] = @story.errors.full_messages
      render :new
    end
  end

  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: "Story was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def bulk_destroy
    Story.where(id: params[:ids]).destroy_all
    respond_to do |format|
      format.json { render json: :ok }
    end
  end

  def show
    @estimate = Estimate.where(story: @story, user: current_user).first
  end

  def update
    if @story.update_attributes(stories_params)
      flash[:success] = "Story updated!"
      redirect_to project_path(@project.id)
    else
      flash[:error] = @story.errors.full_messages
      render :edit
    end
  end

  def import

    if !params[:file].original_filename.ends_with?(".csv")
      flash[:error] = "Invalid File: Must be CSV"
      redirect_to(@project) and return
    end
    file = CSV.parse(params[:file].read, headers: true) rescue []
    if file.empty?
      flash[:error] = "CSV Error: File is empty or could not be parsed"
      redirect_to(@project) and return
    elsif !expected_csv_headers?(file)
      flash[:error] = "Invalid CSV: Must have headers title,description,position"
      redirect_to(@project) and return
    else
      file.each do |story_csv|
        story = @project.stories.where(id: story_csv['id']).first || @project.stories.new
        story.update(title: story_csv['title'], description: story_csv['description'], position: story_csv['position'])
      end
      flash[:success] = "CSV import was successful"
      redirect_to project_path(@project)
    end
  end

  def export
    csv = CSV.generate(headers: true) do |csv|
      csv << CSV_HEADERS
      @project.stories.each do |story|
        csv << story.attributes.slice(*CSV_HEADERS)
      end
    end
    filename = "#{@project.title.gsub(/[^\w]/, '_')}-#{Time.now.to_s(:short).gsub(" ", '_')}.csv"
    send_data csv, filename: filename
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_story
    @story = Story.find(params[:id])
  end

  def stories_params
    params.require(:story).permit(:title, :description, :project_id)
  end

  def expected_csv_headers?(file)
    ['title', 'description', 'position'].to_set.subset?(file.headers.to_set)
  end
end
