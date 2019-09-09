require 'acceptance_helper'

resource 'Teams' do
  header "Content-Type", "application/json"
  authentication :basic, :api_key

  explanation "Manage the teams in the system."

  attribute :name, 'The name of the team', required: true
  attribute :team_number, 'The number of the team in a league (if any)'

  let(:api_key) { generate_api_key }
  let(:user) { User.find 1 }

  route '/teams/all', 'All Teams' do
    get 'List All Teams' do
      context 'when request is valid' do
        example_request 'list teams' do
          expect(status).to eq(200)
          expect(json).to be_an_instance_of(Array)
        end
      end
    end
  end

  route '/teams', 'Teams Collection' do
    get 'List My Teams' do
      context 'when request is valid' do
        example_request 'retrieve my teams' do
          expect(status).to eq(200)
          expect(json).to be_an_instance_of(Array)
        end
      end
    end

    post 'Create a Team' do
      # create user
      let(:name) { 'Ravens' }
      let(:team_number) { '1642' }

      attribute :name, 'The name of the team', required: true
      attribute :team_number, 'The number of the team in a league (if any)'

      # send it as a json post in the body
      let(:raw_post) { params.to_json }

      context 'when request is valid' do
        example_request 'team is created' do
          team = Team.find 1
          expect(status).to eq(201)
          expect(response_body).to eq team.to_json
        end
      end
    end
  end

  route '/teams/:id', 'Single Team' do
    parameter :id, 'Team id', type: :integer, required: true
    let(:team1) { Team.create(name: 'Delete Me', team_number: 1) }
    let(:team2) { Team.create(name: 'Delete Me But Cant', team_number: 2) }
    let(:id) { team1.id }

    before do
      user = User.find(1)
      TeamMember.create!(user: user, team: team1, role: 'admin')
      TeamMember.create!(user: user, team: team2, role: 'player')
    end

    get 'Retrieve a Team' do
      context 'when team exists' do
        example_request 'team is returned' do
          expect(status).to eq(200)
          expect(response_body).to eq team1.to_json
        end
      end
    end

    put 'Modify a Team' do
      let(:request) {{ name: "Team was updated", team_number: 1337 }}
      context 'when team exists' do
        example 'team is returned' do
          do_request(request)
          expect(status).to eq(200)
          expect(json['name']).to eq request[:name]
        end
      end

      context 'when team does not exist' do
        let(:id) { 666 }
        example 'resource not found' do
          do_request(request)
          expect(status).to eq(404)
          expect(response_body).to match(/Couldn't find Team with/)
        end
      end
    end

    delete 'Delete a Team' do
      context 'when team exists' do
        example_request 'team is deleted' do
          expect(status).to eq(204)
          expect(response_body).to eq('')
          # make sure it was actually deleted
          expect(Team.find_by_id(id)).to eq(nil)
        end
      end

      context 'when user does not have access' do
        let(:id) { team2.id }
        example_request 'team cannot be deleted' do
          expect(status).to eq(403)
          expect(response_body).to match(/you do not have access to modify this resource/)
          expect(Team.find_by_id(id)).to_not eq(nil)
        end
      end

      context 'when team does not exist' do
        let(:id) { 9000 }
        example_request 'team is not found' do
          expect(status).to eq(404)
          expect(response_body).to match(/Couldn't find Team with/)
        end
      end
    end

  end
end
