class TaskSerializer < ActiveModel::Serializer
  attributes :id, :state, :title, :body, :user_id, :task_type
end
