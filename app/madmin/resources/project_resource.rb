class ProjectResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :title
  attribute :status

  # Associations
  attribute :stories
  attribute :estimates
  attribute :users
  attribute :parent
  attribute :projects

  def self.display_name(record)
    record.title.truncate(20)
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
