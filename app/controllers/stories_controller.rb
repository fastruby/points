require "csv"
class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, except: [:bulk_destroy, :render_markdown, :edit, :update, :destroy, :show, :move]
  before_action :find_story, only: [:edit, :update, :destroy, :show, :move]
  before_action :validate_url_product_id, only: [:edit, :update, :destroy, :show, :move]
  before_action :ensure_unarchived!, except: [:show, :bulk_destroy, :render_markdown, :move]

  include ApplicationHelper

  CSV_HEADERS = %w[id title description position]

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
    if @story.update(stories_params)
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
      redirect_to(@project) && return
    end
    file = begin
      CSV.parse(params[:file].read, headers: true)
    rescue
      []
    end
    if file.empty?
      flash[:error] = "CSV Error: File is empty or could not be parsed"
      redirect_to(@project) && return
    elsif !expected_csv_headers?(file)
      flash[:error] = "Invalid CSV: Must have headers title,description,position"
      redirect_to(@project) && return
    else
      file.each do |story_csv|
        story = @project.stories.where(id: story_csv["id"]).first || @project.stories.new
        story.update(title: story_csv["title"], description: story_csv["description"], position: story_csv["position"])
      end
      flash[:success] = "CSV import was successful"
      redirect_to project_path(@project)
    end
  end

  def export
    csv = CSV.generate(headers: true) { |csv|
      csv << CSV_HEADERS
      @project.stories.by_position.each do |story|
        csv << story.attributes.slice(*CSV_HEADERS)
      end
    }
    filename = "#{@project.title.gsub(/[^\w]/, "_")}-#{Time.now.to_s(:short).tr(" ", "_")}.csv"
    send_data csv, filename: filename
  end

  def render_markdown
    render plain: markdown(params[:markdown])
  end

  def move
    @new_project = @project.siblings.find_by(id: params[:to_project])

    if @new_project
      @story.update_attribute(:project_id, @new_project.id)
      flash[:success] = "Story moved!"
    else
      flash[:error] = "Selected project does not exist or is not a sibling."
    end

    redirect_to @project
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_story
    @story = Story.find(params[:id] || params[:story_id])
    @project = @story.project
  end

  def validate_url_product_id
    raise ActionController::RoutingError.new("This story was not found for this project") unless params[:project_id] == @project.id.to_s
  end

  def stories_params
    params.require(:story).permit(:title, :description, :extra_info, :project_id)
  end

  def expected_csv_headers?(file)
    ["title", "description", "position"].to_set.subset?(file.headers.to_set)
  end
end
