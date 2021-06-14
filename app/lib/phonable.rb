# frozen_string_literal: true

module Phonable
  def self.parse(number)
    Phonelib.parse(number, 'gb').full_e164
  end
end
