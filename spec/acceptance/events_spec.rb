require 'acceptance_helper'

resource 'Events & Games' do
  header "Content-Type", "application/json"
  authentication :basic, :api_key

  explanation "Manage team events and games."

  attribute :event_type, 'The type of the event. Must be one of: game, event', type: :string, required: true
  attribute :home_team_id, 'The team this event belongs to', type: :integer, required: true
  attribute :away_team_id, 'The team that will be away. For game types only', type: :integer
  attribute :home_score, 'The current score for the home team', type: :integer
  attribute :away_score, 'The current score for the away team', type: :integer

  attribute :location_name, 'Name of the location where the event or game is held', type: :string, required: true
  attribute :location_address, 'Address where the event or game is held', type: :string, required: true
  attribute :location_detail, 'Additional details to show for the event location', type: :string
  attribute :start_at, 'Date and time when the event is scheduled to start'
  attribute :started_at, 'Timestamp when the game started. Only used for games'
  attribute :ended_at, 'Timestamp when the game ended. Only used for games'

  let(:api_key) { generate_api_key }
  let(:home_team) { team.id }
  let(:team) do
    # team = Team.create(name: 'Ravens', team_number: 1)
    # TeamMember.create(user: user, team: team, role: 'admin')
    # TeamMember.create(user: player, team: team, role: 'player', jersey_number: '05')
    #
    # team
  end

  route '/events', 'All Events Collection' do

    get 'Events for My Teams' do
      context 'when request is valid' do
        example_request 'list events' do
          expect(status).to eq(200)
          expect(json).to be_an_instance_of(Array)
        end
      end
    end

    post 'Add Event for Team' do
      let(:params) { FactoryBot.build(:event, home_team_id: 1) }

      context 'when request is valid' do
        example 'successfully add event' do
          do_request(params.as_json)
          expect(status).to eq(201)
          expect(json['id'].nil?).to eq false
          e = Event.find json['id']
          expect(response_body).to eq(e.as_json)
        end
      end
    end

    post 'Add Game for Team' do
      let(:params) { FactoryBot.attributes_for(:game, home_team_id: 1, away_team_id: 2) }

      context 'when request is valid' do
        example 'successfully add event' do
          do_request(params.as_json)
          expect(status).to eq(201)
          expect(json['id'].nil?).to eq false
          e = Event.find json['id']
          expect(response_body).to eq(e.as_json)
        end
      end
    end
  end

end
