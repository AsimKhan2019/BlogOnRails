# frozen_string_literal: true

require 'rails_helper'

# spec/swagger_helper.rb
RSpec.configure do |config|
  config.swagger_format = :yaml
  config.swagger_root = Rails.root.to_s + '/swagger'

  config.swagger_docs = {
    'v1/swagger.json' => {
      ...  # note the new Open API 3.0 compliant security structure here, under "components"
      components: {
        securitySchemes: {
          basic_auth: {
            type: :http,
            scheme: :basic
          },
          api_key: {
            type: :apiKey,
            name: 'api_key',
            in: :query
          }
        }
      }
    }
  }
end

# spec/requests/blogs_spec.rb
describe 'Blogs API' do

  path '/blogs' do

    post 'Creates a blog' do
      tags 'Blogs'
      security [ basic_auth: [] ]
      ...

      response '201', 'blog created' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('jsmith:jspass')}" }
        run_test!
      end

      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end
end

# example of documenting an endpoint that handles basic auth and api key based security
describe 'Auth examples API' do
  path '/auth-tests/basic-and-api-key' do
    post 'Authenticates with basic auth and api key' do
      tags 'Auth Tests'
      operationId 'testBasicAndApiKey'
      security [{ basic_auth: [], api_key: [] }]

      response '204', 'Valid credentials' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('jsmith:jspass')}" }
        let(:api_key) { 'foobar' }
        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('jsmith:jspass')}" }
        let(:api_key) { 'bar-foo' }
        run_test!
      end
    end
  end
end


