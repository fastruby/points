class Story < ApplicationRecord
  belongs_to :project

  has_many :estimates
end
