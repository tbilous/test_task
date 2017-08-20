class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :teams, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :approved_collaborators, -> { where(collaborators: { status: 'approved' }) }, class_name: 'Collaborator'
  has_many :awaiting_collaborators, -> { where(collaborators: { status: 'awaiting' }) }, class_name: 'Collaborator'
  has_many :rejected_collaborators, -> { where(collaborators: { status: 'rejected' }) }, class_name: 'Collaborator'
  has_many :teams_collaborator, through: :collaborators, source: :team
  has_many :tasks

  scope :not_in_team, (lambda do |team, user_id|
    where.not(id: user_id).joins('LEFT JOIN collaborators ON collaborators.user_id = users.id')
      .where('collaborators.team_id != ? OR collaborators.id is null', team.id)
  end)

  scope :mail_select, (->(query) { where('email LIKE :query', query: "%#{query}%") })

  def self.select_search(query)
    where(nil).mail_select(query)
  end

  def owner_of?(object)
    id == object.user_id
  end

  def his_name_is
    email.split('@').first
  end
end
