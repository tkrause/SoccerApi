class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :team_number

      t.timestamps
    end

    create_table :team_user, id: false do |t|
      t.integer :user_id
      t.integer :team_id

      t.string :role, default: 'player'
    end
  end
end
