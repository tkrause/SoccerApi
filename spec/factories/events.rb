FactoryBot.define do
  factory :event do
    event_type       { 'event' }
    home_score       { nil }
    away_score       { nil }
    location_name    { Faker::Restaurant.name }
    location_address { Faker::Address.full_address }
    location_detail  { Faker::Lorem.sentence }
    start_at         { Faker::Time.forward(days: 56, period: :day) }
  end

  trait :game do
    event_type { 'game' }
    home_score { Faker::Number.within(range: 1..10) }
    away_score { Faker::Number.within(range: 1..10) }
  end
end

# :event_type
# :home_team_id
# :away_team_id
# :home_score
# :away_score
# :location_name
# :location_address
# :location_detail
# :start_at
# :started_at
# :ended_at