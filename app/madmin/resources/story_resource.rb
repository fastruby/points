class StoryResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :title
  attribute :description
  attribute :real_score
  attribute :extra_info

  # Associations
  attribute :project
  attribute :estimates
  attribute :users

  def self.display_name(record)
    record.title.truncate(30)
  end

  # Uncomment this to customize the default sort column and direction.
  # def self.default_sort_column
  #   "created_at"
  # end
  #
  # def self.default_sort_direction
  #   "desc"
  # end
end
