module Madmin
  class ApplicationController < Madmin::BaseController
    include Pundit::Authorization
    before_action :ensure_admin

    def ensure_admin
      redirect_to "/" if current_user.nil? || !current_user.admin
    end
  end
end
