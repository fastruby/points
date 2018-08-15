class Story < ApplicationRecord
  validates :title, presence: true

  belongs_to :project

  has_many :estimates

  def best_estimate_average
    return 0 if self.estimates.length < 2

    best_cases = self.estimates.pluck(:best_case_points)
    best_cases.sum / best_cases.length
  end

  def worst_estimate_average
    return 0 if self.estimates.length < 2

    worst_cases = self.estimates.pluck(:worst_case_points)
    worst_cases.sum / worst_cases.length
  end

end
