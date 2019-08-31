require 'acceptance_helper'

resource 'Authentication' do
  header "Content-Type", "application/json"

  explanation "Authenticate using a users credentials. Returns a JWT that can be used to interact with the API."

  let(:user) { User.create(name: 'Test User', email: 'user@example.com', password: '0987654321') }

  post '/authenticate' do
    let(:email) { user.email }
    let(:password) { '0987654321' }

    parameter :email, 'The email address of the user', required: true
    parameter :password, 'User password to authenticate with', required: true

    # send it as a json post in the body
    let(:raw_post) { params.to_json }

    context '200' do
      example_request 'Successful Login' do
        json = JSON.parse(response_body)

        expect(status).to eq(200)
        expect(json).to have_key('token')
      end
    end

    context '401' do
      let(:email) { 'nonexistentuser@nobody.com' }

      example_request 'Invalid Login Credentials' do
        expect(status).to eq(401)
      end
    end

  end
end