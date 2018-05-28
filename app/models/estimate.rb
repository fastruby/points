class Estimate < ApplicationRecord
  belongs_to :story
  belongs_to :user

  validate :check_estimates

  private

  def check_estimates
    if best_case_points && best_case_points > worst_case_points
      errors.add(:validation_error, "Worst case estimate should be greater than best case estimate.")
    end
  end
end
