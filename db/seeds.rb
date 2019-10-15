# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(name: 'Robert Johnson', email: 'user@example.com', password: '0987654321')
player1 = User.create!(name: 'John Smith', email: 'player@example.com', password: '0987654321')
eric = User.create!(name: 'Eric Ybarra', email: 'eric@example.com', password: 'pass')
william = User.create!(name: 'William Barajas', email: 'will@example.com', password: 'pass')

# teams seeders
team1 = Team.create!(name: 'Guardians', team_number: 506)
team2 = Team.create!(name: 'Ice Breakers', team_number: 611)
ded_team = Team.create!(name: 'Red Devils', team_number: 666)
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
    location_name: 'Menifee Valey High School', location_address: '3241 Valley High, Menifee',
    location_detail: 'Field 1',
    home_team_id: team1.id, away_team_id: team2.id
)

Event.create!(
    event_type: 'game', start_at: 12.days.from_now,
    location_name: 'Lyle Marsh Park', location_address: '27050 Menifee Grove, Menifee',
    location_detail: 'Field 2',
    home_team_id: team2.id, away_team_id: team1.id
)

Event.create!(
    event_type: 'game', start_at: 15.days.from_now,
    location_name: 'Ocean Side Middle School', location_address: '12345 School, Monterrey',
    location_detail: 'Field 3',
    home_team_id: ded_team.id, away_team_id: team1.id
)

