module Sessions
  module Otp
    class ResponseForm < FormObject
      
      attribute :mobile_number, String
      attribute :otp_i1, Integer
      attribute :otp_i2, Integer
      attribute :otp_i3, Integer
      attribute :otp_i4, Integer
      attribute :otp_i5, Integer
      attribute :otp_i6, Integer

      validates :mobile_number, \
        presence: true, \
        phone: { possible: true, types: [:mobile] }

      def one_time_password
        (1..6).map {|n| public_send("otp_i#{n}".to_sym)}.join
      end

    end
  end
end