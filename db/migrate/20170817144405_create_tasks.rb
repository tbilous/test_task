class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true, index: true
      t.references :team, foreign_key: true, index: true
      t.integer :state, default: 0
      t.integer :task_type, null: false
      t.string :title
      t.text :body
      t.datetime :resolved_at

      t.timestamps
    end
  end
end
