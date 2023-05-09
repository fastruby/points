class UserResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :email
  attribute :sign_in_count, form: false
  attribute :current_sign_in_at
  attribute :last_sign_in_at
  attribute :current_sign_in_ip
  attribute :last_sign_in_ip
  attribute :admin
  attribute :name
  attribute :provider
  attribute :uid

  # Associations
  attribute :estimates

  def self.display_name(record)
    record.name.truncate(12)
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
