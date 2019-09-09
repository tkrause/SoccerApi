# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(name: 'Test User', email: 'user@example.com', password: '0987654321')

# teams seeders
# ded_team = Team.create!(name: 'Dummy Team No One Is In', team_number: 666)
# team1 = Team.create!(name: 'Team Win', team_number: 506)
# team2 = Team.create!(name: 'Team Noobs', team_number: 611)
# TeamUser.create!(user: user, team: team1, role: 'admin')
# TeamUser.create!(user: user, team: team2, role: 'player')