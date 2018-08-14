class Project < ApplicationRecord
  validates :title, presence: true

  has_many :stories

  def best_estimate_sum
    stories.sum(&:best_estimate_average)
  end

  def worst_estimate_sum
    stories.sum(&:worst_estimate_average)
  end
end
