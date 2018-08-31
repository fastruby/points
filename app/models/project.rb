class Project < ApplicationRecord
  validates :title, presence: true

  has_many :stories
  has_many :estimates, through: :stories
  has_many :users, through: :estimates

  def best_estimate_sum
    stories.sum do |story|
      story.best_estimate_average
    end
  end

  def worst_estimate_sum
    stories.sum(&:worst_estimate_average)
  end
end
