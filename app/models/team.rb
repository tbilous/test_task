# t.bigint "user_id"
# t.string "title"

class Team < ApplicationRecord
  belongs_to :user
  has_many :collaborators, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :team_users, through: :collaborators, source: :user do
    def awaiting
      where('collaborators.status = ?', 0)
    end

    def approved
      where('collaborators.status = ?', 1)
    end

    def rejected
      where('collaborators.status = ?', 2)
    end
  end
  validates_presence_of :title
end
