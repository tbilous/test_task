class CreateCollaborators < ActiveRecord::Migration[5.1]
  def change
    create_table :collaborators do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :collaborators, %i[user_id team_id], unique: true
  end
end
