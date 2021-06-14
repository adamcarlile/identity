# frozen_string_literal: true

module Helpers
  def parse_response(response, symbolize_names = true)
    JSON.parse response.body, symbolize_names: symbolize_names
  end
end
