class SearchController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def index
    @search_query = params.permit(:query)["query"]
    @results = Story.search_any_word(@search_query)
  end
end
