module Sessions
  module Otp
    class ChallengeForm < FormObject

      attribute :mobile_number, String

      validates :mobile_number, \
        presence: true, \
        phone: { possible: true, types: [:mobile], countries: [:gb] }

      def mobile_number
        Phonable.parse super
      end

    end
  end
end
