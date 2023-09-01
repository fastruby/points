class VersionJump < ApplicationRecord
  has_many :projects

  validates :technology, :initial_version, :target_version, presence: true
  validates :technology, uniqueness: {scope: [:initial_version, :target_version]}

  def to_label
    "#{technology} / #{initial_version} - #{target_version}"
  end
end
