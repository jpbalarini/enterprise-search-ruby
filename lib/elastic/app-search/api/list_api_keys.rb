# frozen_string_literal: true

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

module Elastic
  module EnterpriseSearch
    module AppSearch
      module Actions
        # Credentials - Retrieve all API keys
        # List the details of all API keys
        #
        # @param [Hash] arguments endpoint arguments
        # @param [Integer] current_page The page to fetch. Defaults to 1
        # @param [Integer] page_size The number of results per page
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/credentials.html#credentials-all
        #
        def list_api_keys(arguments = {})
          headers = arguments.delete(:headers) || {}
          request(
            :get,
            'api/as/v1/credentials/',
            arguments,
            nil,
            headers
          )
        end
      end
    end
  end
end
