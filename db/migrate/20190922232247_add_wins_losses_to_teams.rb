class AddWinsLossesToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :wins, :integer, after: :team_number, default: 0
    add_column :teams, :losses, :integer, after: :wins, default: 0
  end
end
