class Comment < ApplicationRecord
  belongs_to :story
  belongs_to :user
  validates :body, presence: true
end
