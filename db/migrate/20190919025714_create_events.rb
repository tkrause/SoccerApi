class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :event_type, default: 'game'

      t.integer :home_team_id
      t.integer :away_team_id, null: true

      t.integer :home_score, default: 0
      t.integer :away_score, default: 0

      t.string :location_name
      t.string :location_address
      t.string :location_detail, null: true

      t.timestamp :start_at
      t.timestamp :started_at, null: true
      t.timestamp :ended_at, null: true
    end
  end
end
