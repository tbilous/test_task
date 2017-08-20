class CollaboratorSerializer < ActiveModel::Serializer
  attributes :id, :team_id, :user_id
  belongs_to :user
end
