class CollaboratorSerializer < ActiveModel::Serializer
  attributes :id, :team_id, :user_id, :status
  belongs_to :user
  belongs_to :team
end
