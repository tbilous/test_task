class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :team_id, uniqueness: { scope: :user_id }

  enum status: { awaiting: 0, approved: 1, rejected: 2 }
end
