module OmbuLabs
  module Auth
    class ApplicationController < ActionController::Base
      def after_sign_in_path_for(resource)
        request.base_url
      end
    end
  end
end
