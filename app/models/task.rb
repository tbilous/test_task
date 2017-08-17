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

    event :resolve do
      before do
        self.resolved_at = Time.current
      end

      transition %i[open assigned] => :in_progress
    end

    event :close do
      after do
        Notifier.notify "Task##{id} has been done."
      end

      transition all - [:done] => :done
    end
  end

  validates_presence_of :title, :body, :task_type
end
