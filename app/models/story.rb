class Story < ApplicationRecord
  validates :title, presence: true

  belongs_to :project

  has_many :estimates
end
