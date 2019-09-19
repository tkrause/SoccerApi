# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(name: 'Test User', email: 'user@example.com', password: '0987654321')
player1 = User.create!(name: 'Player 1', email: 'player@example.com', password: '0987654321')

# teams seeders
10.times { FactoryBot.create(:team) }
team1 = Team.find 1
team2 = Team.find 2
TeamMember.create!(user: user, team: team1, role: 'admin')
TeamMember.create!(user: player1, team: team1, role: 'player')
TeamMember.create!(user: user, team: team2, role: 'player')

# create a few events, games and non games
4.times { FactoryBot.create(:event, home_team_id: team1.id) }
4.times { FactoryBot.create(:event, home_team_id: team2.id) }
FactoryBot.create(:event, :game, home_team_id: team1.id, away_team_id: team2.id)
FactoryBot.create(:event, :game, home_team_id: team2.id, away_team_id: team1.id)
# Event.create!()


