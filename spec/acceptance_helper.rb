require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  # Output folder
  # config.docs_dir = Rails.root.join("doc", "api")

  # An array of output format(s).
  # Possible values are :json, :html, :combined_text, :combined_json,
  #   :json_iodocs, :textile, :markdown, :append_json
  config.format = [:json, :api_blueprint]
  config.keep_source_order = true
  config.request_headers_to_include = %w(Content-Type Authorization Accept)
  config.response_headers_to_include = %w(Content-Type)
end

def generate_api_key(email = 'user@example.com', password = '0987654321')
  command = AuthenticateUser.call(email, password)
  command.result[:token]
end

def json
  JSON.parse(response_body)
end