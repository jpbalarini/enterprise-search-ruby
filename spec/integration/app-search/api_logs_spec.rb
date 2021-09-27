# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# frozen_string_literal: true

require_relative "#{__dir__}/app_search_helper.rb"

describe Elastic::EnterpriseSearch::AppSearch::Client do
  context 'API logs' do
    let(:engine_name) { 'videogames' }
    let(:api_key_name) { 'logs-api-key' }

    before do
      client.create_engine(name: engine_name)
      # Create API Key Client to log events:
      body = { name: api_key_name, type: 'private', read: true, write: true, access_all_engines: true }
      api_key = client.create_api_key(body: body).body['key']
      private_key_client = Elastic::EnterpriseSearch::AppSearch::Client.new(
        host: ENV['ELASTIC_ENTERPRISE_HOST'] || 'http://localhost:3002',
        http_auth: api_key
      )
      id = private_key_client.index_documents(engine_name, documents: [{ title: 'Test Document' }]).body.first['id']
      private_key_client.documents(engine_name, document_ids: [id])
      private_key_client.delete_documents(engine_name, document_ids: [id])
    end

    after do
      client.delete_engine(engine_name)
      client.delete_api_key(api_key_name: api_key_name)
    end

    it 'returns api logs' do
      response = client.api_logs(engine_name, from_date: Date.today - 1, to_date: Date.today + 1)
      expect(response.status).to eq 200

      attempts = 0
      while response.body['results'].count < 1 && attempts < 20
        sleep 1
        attempts += 1
        response = client.api_logs(engine_name, from_date: Date.today - 1, to_date: Date.today + 1)
      end
      expect(response.body['results'].count).to be >= 1
    end
  end
end