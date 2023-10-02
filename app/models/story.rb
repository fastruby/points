class Story < ApplicationRecord
  validates :title, presence: true

  belongs_to :project
  has_many :estimates
  has_many :users, through: :estimates

  before_create :add_position

  enum :status, [:pending, :approved, :rejected]

  scope :by_position, -> { order("stories.position ASC NULLS FIRST, stories.created_at ASC") }

  def best_estimate_average
    return 0 if estimates_count < 2

    best_cases = users_estimates.map(&:best_case_points)
    (best_cases.sum / users_estimates.length.to_f).round(2)
  end

  def worst_estimate_average
    return 0 if estimates_count < 2

    worst_cases = users_estimates.map(&:worst_case_points)
    (worst_cases.sum / users_estimates.length.to_f).round(2)
  end

  def estimate_for(user)
    # cache the estimate for each user to not process it every time
    @estimate_for ||= {}
    # use the `estimates` association directly to use the cached query to prevent N+1
    @estimate_for[user] ||= estimates.select { |e| e.user == user }.min_by { |e| e.id }
    @estimate_for[user]
  end

  def best_estimate_for(user)
    estimate_for(user)&.best_case_points || 0
  end

  def worst_estimate_for(user)
    estimate_for(user)&.worst_case_points || 0
  end

  def percentage_off_estimate(estimate_average)
    if estimate_average != 0 && !real_score.nil?
      ((estimate_average - real_score).abs / estimate_average) * 100
    else
      0
    end
  end

  def estimates_count
    users_estimates.count
  end

  def users_estimates
    @users_estimates ||= users.distinct.map { |u| estimate_for(u) }
  end

  private

  def add_position
    return if position

    last_position = project.stories.where.not(position: nil).order(position: :asc).last&.position || 0
    self.position = last_position + 1
  end
end
