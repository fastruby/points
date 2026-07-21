require "csv"
class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, except: [:bulk_destroy, :render_markdown, :edit, :update, :destroy, :show, :move, :approve, :reject, :pending]
  before_action :find_story, only: [:edit, :update, :destroy, :show, :move, :approve, :reject, :pending]
  before_action :validate_url_product_id, only: [:edit, :update, :destroy, :show, :move]
  before_action :ensure_unarchived!, except: [:show, :bulk_destroy, :render_markdown, :move]

  include ApplicationHelper

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
    with_comments = params[:export_with_comments] == "1"
    # Only admins may export non-approved stories. Enforce it here rather than
    # relying on the checkbox being hidden in the view, so the param can't be
    # forged by a non-admin.
    export_all = params[:export_all] == "1" && current_user.admin?

    stories = export_all ? @project.stories : @project.stories.approved
    # Eager-load the comments and their authors; generate_csv reads
    # comment.user for every comment, which would otherwise be an N+1.
    stories = stories.includes(comments: :user) if with_comments

    csv = generate_csv(stories, with_comments: with_comments)

    filename = "#{@project.title.gsub(/[^\w]/, "_")}-#{Time.now.to_formatted_s(:short).tr(" ", "_")}.csv"
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

  def generate_csv(stories, with_comments: false)
    CSV.generate(headers: true) do |csv|
      headers = %w[id position status title description]
      headers << "comments" if with_comments
      csv << headers

      stories.by_position.each do |story|
        row = [story.id, story.position, story.status, story.title, story.description]

        # Keep every story on a single, uniform-width row: collapse all comments
        # into one cell instead of spilling into a variable number of trailing,
        # unlabeled columns.
        if with_comments
          row << story.comments.map { |comment| "#{display_name(comment.user)}: #{comment.body}" }.join("\n")
        end

        csv << row
      end
    end
  end

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
