# t.bigint "user_id"
# t.string "title"

class Team < ApplicationRecord
  belongs_to :user

  validates_presence_of :title
end
