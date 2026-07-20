class VersionJumpResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :technology, index: true
  attribute :initial_version, index: true
  attribute :target_version, index: true

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
