FactoryBot.define do
  factory :team do
    name       { Faker::Team.name }
    sequence(:team_number) { |n| n }
  end
end

