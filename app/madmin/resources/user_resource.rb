class UserResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :email
  attribute :name
  attribute :admin

  # Associations
  attribute :estimates

  def self.display_name(record)
    record.name.truncate(12) || record.email.truncate(12)
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
