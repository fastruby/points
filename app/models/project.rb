class Project < ApplicationRecord
  validates :title, presence: true

  has_many :stories
  has_many :estimates, through: :stories
  has_many :users, through: :estimates

  def best_estimate_total
    stories.sum(&:best_estimate_average)
  end

  def worst_estimate_total
    stories.sum(&:worst_estimate_average)
  end

  def real_score_total
    stories.collect(&:real_score).compact.sum
  end

  def best_estimate_sum_per_user(user)
    stories.sum { |x| x.best_estimate_sum(user) }
  end

  def worst_estimate_sum_per_user(user)
    stories.sum { |x| x.worst_estimate_sum(user) }
  end

end
