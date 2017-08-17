# t.bigint "user_id"
# t.string "title"

class Team < ApplicationRecord
  belongs_to :user
  has_many :collaborators, dependent: :destroy

  validates_presence_of :title
end
