class Task < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum task_type: { bug_fix: 0, code: 1, test: 2 }

  enum state: { open: 0, assigned: 1, in_progress: 2, done: 3 } do
    event :assign do
      transition open: :assigned
    end

    event :progress do
      transition assigned: :in_progress
    end

    event :close do
      before do
        self.resolved_at = Time.current
      end
      transition all - [:done] => :done
    end

    event :resolve do
      before do
        self.resolved_at = Time.current
      end

      transition %i[open assigned in_progress] => :done
    end
  end

  validates_presence_of :title, :body, :task_type

  scope :ready, (-> { where('state IN (1, 2)') })

  def self.type_attributes_for_select
    task_types.map do |type, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.type.#{type}"), type]
    end
  end

  def self.state_attributes_for_select
    states.map do |type, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.state.#{type}"), type]
    end
  end

  def next_role
    Task.states.key(Task.states[state] + 1)
  end
end
