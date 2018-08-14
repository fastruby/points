class Story < ApplicationRecord
  validates :title, presence: true

  belongs_to :project

  has_many :estimates

  def best_estimate_average
    best_case = self.estimates.pluck(:best_case_points)
    best_case.sum / best_case.length
  end

  def worst_estimate_average
    worst_case = self.estimates.pluck(:worst_case_points)
    worst_case.sum / worst_case.length
  end

end
