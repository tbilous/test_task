class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :teams, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :teams_collaborator, through: :collaborators, source: :team
  has_many :tasks

  def owner_of?(object)
    id == object.user_id
  end

  def his_name_is
    email.split('@').first
  end
end
