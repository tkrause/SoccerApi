require 'acceptance_helper'

resource 'Users' do
  header "Content-Type", "application/json"
  authentication :basic, :api_key

  explanation "Interact with users in the system."

  let(:api_key) { generate_api_key }
  let(:user) { User.find 1 }

  attribute :name, 'The name of the user', type: :string, required: true
  attribute :email, 'The email address of the user', type: :string, required: true
  attribute :password, 'Password to user for the new user', type: :string, required: true

  route '/users/current', 'Current User' do
    # get current user
    get 'Retrieve current user' do
      context 'when logged in' do
        example_request 'retrieve current user' do
          expect(status).to eq(200)
          expect(response_body).to eq user.to_json
        end
      end

      context 'when token invalid or expired' do
        let(:api_key) { 'Expired_Key' }
        example_request 'invalid or expired token' do
          expect(status).to eq(401)
          expect(response_body).to match(/unauthorized/)
        end
      end
    end
  end

  route '/users', 'Users Collection' do
    post 'Register Account' do
      authentication :basic, nil

      # create user
      let(:name) { 'New User' }
      let(:email) { 'new-user@example.com' }
      let(:password) { '0987654321' }
      let(:password_confirmation) { password }

      attribute :password_confirmation, 'Confirmation password', type: :string, required: true

      # send it as a json post in the body
      let(:raw_post) { params.to_json }

      context 'when request is valid and email not taken' do
        example_request 'user created' do
          expect(status).to eq(201)
          expect(json['email']).to eq(email)
        end
      end

      context 'when email is already taken' do
        let(:email) { 'user@example.com' }
        example_request 'non unique email' do
          expect(status).to eq(422)
          expect(response_body).to match(/Email has already been taken/)
        end
      end
    end
  end
end