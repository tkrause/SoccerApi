require 'acceptance_helper'

resource 'Team Members' do
  header "Content-Type", "application/json"
  authentication :basic, :api_key

  explanation "Manage team memberships."

  attribute :user_id, 'The id of the user to add', required: true
  attribute :role, 'The role of the user in the team. Must be one of: admin, player, coach', type: :string, required: true
  attribute :jersey_number, 'The jersey number of the person on the team', type: :string

  parameter :team_id, 'Team id', type: :integer, required: true

  let(:api_key) { generate_api_key }
  let(:user) { User.find 1 }
  let(:player) { User.find 2 }
  let(:team_id) { team.id }
  let(:team) do
    team = Team.create(name: 'Ravens', team_number: 1)
    TeamMember.create(user: user, team: team, role: 'admin')
    TeamMember.create(user: player, team: team, role: 'player', jersey_number: '05')

    team
  end

  route '/teams/:team_id/members', 'Team Members Collection' do

    get 'List Team Members' do
      context 'when request is valid' do
        example_request 'list members' do
          expect(status).to eq(200)
          expect(json).to be_an_instance_of(Array)
        end
      end
    end

    post 'Add Team Member' do
      let(:user_id) { 3 }
      let(:role) { 'player' }
      let(:jersey_number) { '00' }

      context 'when request is valid' do
        example_request 'successfully add team member' do
          expect(status).to eq(201)
          expect(json).to be_an_instance_of(Array)
        end
      end
    end
  end

  route '/teams/:team_id/members/:id', 'Single Team Member' do
    get 'Retrieve a Team Member' do
      let(:id) { 2 }

      context 'when request is valid' do
        example_request 'retrieve a team member' do
          expect(status).to eq(200)
          member = TeamMember.where(team_id: team_id, user_id: id).first
          expect(response_body).to eq(member.to_json)
        end
      end
    end

    put 'Modify a Team Member' do
      let(:user_id) { 2 }
      let(:id) { user_id }
      let(:role) { 'coach' }
      let(:jersey_number) { nil }

      context 'when request is valid' do
        example_request 'modify team member role' do
          expect(status).to eq(200)
          expect(json['jersey_number']).to eq(jersey_number)
          expect(json['role']).to eq(role)
        end
      end

      context 'when role is invalid' do
        let(:role) { 'suckaphatone' }
        example_request 'modify with invalid role' do
          expect(status).to eq(422)
          expect(response_body).to match(/is not a valid role/)
        end
      end
    end

    delete 'Remove a Team Member' do
      context 'when the member exists' do
        let(:id) { 2 }
        example_request 'remove team member' do
          expect(status).to eq(204)
          expect(response_body).to eq('')
          # make sure it was actually deleted
          expect(TeamMember.where(team_id: team_id, user_id: id).count).to eq(0)
        end
      end

      context 'when the member does not exist' do
        let(:id) { 666 }
        example_request 'attempt to remove non team member' do
          expect(status).to eq(404)
          expect(response_body).to match(/Couldn't find TeamMember with/)
        end
      end
    end
  end

end
