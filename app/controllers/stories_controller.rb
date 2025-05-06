require "csv"
class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, except: [:bulk_destroy, :render_markdown, :edit, :update, :destroy, :show, :move, :approve, :reject, :pending]
  before_action :find_story, only: [:edit, :update, :destroy, :show, :move, :approve, :reject, :pending]
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
    @estimate = Estimate.find_by(story: @story, user: current_user)
    @comments = @story.comments.includes(:user).order(:created_at)
    @comment = Comment.new
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
        story = @project.stories.find_by(id: story_csv["id"]) || @project.stories.new
        story.update(title: story_csv["title"], description: story_csv["description"], position: story_csv["position"])
      end
      flash[:success] = "CSV import was successful"
      redirect_to project_path(@project)
    end
  end

  def export
    csv = if params[:export_with_comments] == "1" && params[:export_all] == "1"
      generate_csv(@project.stories.includes(:comments), with_comments: true, export_all: true)
    elsif params[:export_with_comments] == "1"
      generate_csv(@project.stories.includes(:comments).approved, with_comments: true, export_all: false)
    elsif params[:export_all] == "1"
      generate_csv(@project.stories, with_comments: false, export_all: true)
    else
      generate_csv(@project.stories.approved, with_comments: false, export_all: false)
    end

    filename = "#{@project.title.gsub(/[^\w]/, "_")}-#{Time.now.to_formatted_s(:short).tr(" ", "_")}.csv"
    send_data csv, filename: filename
  end

  def generate_csv(stories, with_comments: false, export_all: false)
    CSV.generate(headers: true) do |csv|
      headers = CSV_HEADERS.dup
      headers << "comment" if with_comments
      csv << headers

      stories.by_position.each do |story|
        comments = []

        if with_comments
          comments = story.comments.map do |comment|
            "#{display_name(comment.user)}: #{comment.body}"
          end
        end

        csv << [story.id, story.title, story.description, story.position] + comments
      end
    end
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

  def approve
    @story.approved!
    respond_to do |format|
      format.js { render "shared/update_status" }
    end
  end

  def reject
    @story.rejected!
    respond_to do |format|
      format.js { render "shared/update_status" }
    end
  end

  def pending
    @story.pending!
    respond_to do |format|
      format.js { render "shared/update_status" }
    end
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
    params.require(:story).permit(:title, :description, :extra_info, :project_id, :status)
  end

  def expected_csv_headers?(file)
    ["title", "description", "position"].to_set.subset?(file.headers.to_set)
  end
end
