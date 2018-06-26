class Project < ApplicationRecord
  validates :title, presence: true

  has_many :stories
end
