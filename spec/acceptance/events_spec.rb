require 'acceptance_helper'

resource 'Events and Games' do
  header "Content-Type", "application/json"
  authentication :basic, :api_key

  explanation "Manage team events and games."

  attribute :event_type, 'The type of the event. Must be one of: game, event', type: :string, required: true
  attribute :home_team_id, 'The team this event belongs to', required: true
  attribute :away_team_id, 'The team that will be away. For game types only'
  attribute :home_score, 'The current score for the home team'
  attribute :away_score, 'The current score for the away team'

  attribute :location_name, 'Name of the location where the event or game is held', type: :string, required: true
  attribute :location_address, 'Address where the event or game is held', type: :string, required: true
  attribute :location_detail, 'Additional details to show for the event location', type: :string
  attribute :start_at, 'Date and time when the event is scheduled to start'
  attribute :started_at, 'Timestamp when the game started. Only used for games'
  attribute :ended_at, 'Timestamp when the game ended. Only used for games'

  let(:api_key) { generate_api_key }
  let(:home_team) { team.id }
  let(:user) { User.find 1 }

  before do
    team = Team.create!(name: 'Ravens', team_number: 777)
    TeamMember.create!(user: user, team: team, role: 'admin')

    team2 = Team.create!(name: 'Devils', team_number: 666)
    TeamMember.create!(user: user, team: team2, role: 'admin')

    Team.create(name: 'Breakers', team_number: 99)
    Team.create(name: 'Rawwhhh!', team_number: 1)

    4.times { FactoryBot.create(:event, home_team_id: 1) }
    FactoryBot.create(:event, home_team_id: 4)
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

    post 'Create a Event' do
      let(:params) { FactoryBot.attributes_for(:event, home_team_id: 1) }

      context 'when request is valid' do
        example 'successfully add event' do
          do_request({ data: params })

          expect(status).to eq(201)
          expect(json['id'].nil?).to eq false

          e = Event.find json['id']
          expect(response_body).to eq(e.to_json)
        end
      end
    end

    post 'Create a Game' do
      let(:params) { FactoryBot.attributes_for(:event, :game, home_team_id: 1, away_team_id: 2) }

      context 'when request is valid' do
        example 'successfully add event' do
          do_request({ data: params })
          expect(status).to eq(201)
          expect(json['id'].nil?).to eq false

          e = Event.find json['id']
          expect(response_body).to eq(e.to_json)
        end
      end

      context 'when user is not manager of team' do
        let(:params) { FactoryBot.attributes_for(:event, :game, home_team_id: 3, away_team_id: 4) }

        example 'fails due to permissions' do
          do_request({ data: params })

          expect(status).to eq(403)
          expect(response_body).to match(/you do not have access to modify this resource/)
        end
      end
    end
  end

  route '/teams/:team_id/events', 'Events for a Team' do
    parameter :id, 'Team id', type: :integer, required: true

    let(:team_id) { 1 }

    get 'Retrieve Team Events' do
      context 'when the team exists' do
        example_request 'successfully get team events' do
          expect(status).to eq(200)
          expect(json).to be_an_instance_of(Array)
        end
      end
    end
  end

  route '/events/:id', 'Single Event' do
    let(:id) { 1 }

    get 'Retrieve an Event' do
      example_request 'successfully get the event' do
        expect(status).to eq(200)
        e = Event.find(id)
        expect(response_body).to eq(e.to_json)
      end
    end

    put 'Modify an Event' do
      let(:request) {{ location_name: "Event was updated" }}
      context 'when event exists' do
        example 'event is returned' do
          do_request(request)
          expect(status).to eq(200)
          expect(json['location_name']).to eq request[:location_name]
        end
      end

      context 'when event does not exist' do
        let(:id) { 666 }
        example 'resource not found' do
          do_request(request)
          expect(status).to eq(404)
          expect(response_body).to match(/Couldn't find Event with/)
        end
      end
    end

    delete 'Delete an Event' do
      context 'when event exists' do
        example_request 'event is deleted' do
          expect(status).to eq(204)
          expect(response_body).to eq('')
          # make sure it was actually deleted
          expect(Event.find_by_id(id)).to eq(nil)
        end
      end

      context 'when user does not have access' do
        let(:id) { 5 }
        example_request 'event cannot be deleted' do
          expect(status).to eq(403)
          expect(response_body).to match(/you do not have access to modify this resource/)
          expect(Event.find_by_id(id)).to_not eq(nil)
        end
      end

      context 'when event does not exist' do
        let(:id) { 9000 }
        example_request 'event is not found' do
          expect(status).to eq(404)
          expect(response_body).to match(/Couldn't find Event with/)
        end
      end
    end
  end

end
