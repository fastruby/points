class Story < ApplicationRecord
  validates :title, presence: true

  belongs_to :project

  has_many :estimates

  def best_estimate_average
    return 0 if estimates.length < 2

    best_cases = self.estimates.pluck(:best_case_points)
    (best_cases.sum / best_cases.length.to_f).round(2)
  end

  def worst_estimate_average
    return 0 if estimates.length < 2

    worst_cases = self.estimates.pluck(:worst_case_points)
    (worst_cases.sum / worst_cases.length.to_f).round(2)
  end

  def best_estimate_sum(user)
    estimates.where(user: user).sum(:best_case_points)
  end

  def worst_estimate_sum(user)
    estimates.where(user: user).sum(:worst_case_points)
  end

  def percentage_off_estimate(estimate_average)
    if estimate_average != 0 && !real_score.nil?
      ((estimate_average - self.real_score).abs / estimate_average) * 100
    else
      0
    end
  end
end
