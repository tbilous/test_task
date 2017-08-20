class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :use_name

  def use_name
    object.his_name_is.capitalize
  end
end
