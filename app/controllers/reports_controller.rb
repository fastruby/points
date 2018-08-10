class ReportsController < ApplicationController

  before_filter :ensure_admin

  def index
  end

  def ensure_admin
    redirect_to root_path unless current_user.admin
  end
end
