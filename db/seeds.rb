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
team1 = Team.create!(name: 'Team Win', team_number: 506)
team2 = Team.create!(name: 'Team Noobs', team_number: 611)
ded_team = Team.create!(name: 'Dummy Team No One Is In', team_number: 666)
TeamMember.create!(user: user, team: team1, role: 'admin')
TeamMember.create!(user: player1, team: team1, role: 'player')
TeamMember.create!(user: user, team: team2, role: 'player')

# create a few events, games and non games
Event.create!(
    event_type: 'event', start_at: 10.days.from_now,
    location_name: 'Chucky Cheese', location_address: '27019 Chucky Cheese, United States',
    location_detail: 'Team Party', home_team_id: team1.id
)

Event.create!(
    event_type: 'game', start_at: 4.days.ago, started_at: 4.days.ago,
    location_name: 'Ocean Side Middle School', location_address: '12345 School, Monterrey',
    location_detail: 'Field 4',
    home_team_id: team1.id, away_team_id: team2.id,
    home_score: 10, away_score: 6,
    ended_at: 4.days.ago.advance(hours: 1)
)

Event.create!(
    event_type: 'game', start_at: 2.days.ago,
    location_name: 'Ocean Side Middle School', location_address: '12345 School, Monterrey',
    location_detail: 'Field 1',
    home_team_id: team1.id, away_team_id: team2.id
)

Event.create!(
    event_type: 'game', start_at: 12.days.from_now,
    location_name: 'Ocean Side Middle School', location_address: '12345 School, Monterrey',
    location_detail: 'Field 2',
    home_team_id: team1.id, away_team_id: team2.id
)

Event.create!(
    event_type: 'game', start_at: 15.days.from_now,
    location_name: 'Ocean Side Middle School', location_address: '12345 School, Monterrey',
    location_detail: 'Field 3',
    home_team_id: team2.id, away_team_id: team1.id
)

