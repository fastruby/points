class VersionJumpResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :technology
  attribute :initial_version
  attribute :target_version

  # Associations
  attribute :projects, form: false

  # Uncomment this to customize the display name of records in the admin area.
  def self.display_name(record)
    record.to_label
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
