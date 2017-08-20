class TaskSerializer < ActiveModel::Serializer
  attributes :id, :status, :title, :body, :user_id, :task_type
end
