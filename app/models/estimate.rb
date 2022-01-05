class Estimate < ApplicationRecord
  belongs_to :story
  belongs_to :user

  validates :best_case_points, :worst_case_points, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :story_id, uniqueness: {scope: :user_id}

  validate :check_estimates

  private

  def check_estimates
    if best_case_points && best_case_points > worst_case_points
      errors.add(:validation_error, "Worst case estimate should be greater than best case estimate.")
    end
  end
end
