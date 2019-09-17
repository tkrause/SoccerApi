class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :team_number

      t.timestamps
    end

    create_table :team_members do |t|
      t.integer :user_id
      t.integer :team_id

      t.string :role, default: 'player'
      t.string :jersey_number, null: true

      t.index [:user_id, :team_id], unique: true
    end
  end
end
