# frozen_string_literal: true

require 'rails_helper'

module SMS
  TWILIO_SMS_SID_REGEX = /SM[0-9a-zA-Z]*/.freeze
  TWILIO_VALID_NUMBER = '+15005550006'
  TWILIO_INVALID_NUMBER = '+15005550001'
  TWILIO_UNROUTABLE_NUMBER = '+15005550002'
  TWILIO_SMS_INCAPABLE_NUMBER = '+15005550009'

  RSpec.describe Adaptors::Twilio do
    describe '#send_sms' do
      subject(:adaptor) do
        described_class.new(
          sid: 'AC3636accfaa34de1f76858aba3e0c0ed3',
          auth_token: 'ec474dd7d46358b21f89532b990b2cc1',
          from: from
        )
      end

      context 'valid phone number' do
        let(:from) { TWILIO_VALID_NUMBER }

        it 'is able to send messages to twilio' do
          message = adaptor.send_sms(to: '+12345678901',
                                        message: 'This is a test')
          expect(message.sid).to match(TWILIO_SMS_SID_REGEX)
          expect(message.status).to eq('queued')
          expect(message.to).to eq('+12345678901')
          expect(message.body).to eq('This is a test')
          expect(message.from).to eq(from)
        end
      end

      context 'invalid destination phone number' do
        let(:from) { TWILIO_VALID_NUMBER }
        subject(:adaptor) do
          described_class.new(
            sid: 'AC3636accfaa34de1f76858aba3e0c0ed3',
            auth_token: 'ec474dd7d46358b21f89532b990b2cc1',
            from: from
          )
        end

        it 'raises an error when twilio says number is invalid' do
          expect do
            adaptor.send_sms(to: TWILIO_INVALID_NUMBER,
                                message: 'This is a test')
          end.to raise_error(SMS::InvalidDestinationNumber)
        end

        it 'raises an error when twilio says number is not routable' do
          expect do
            adaptor.send_sms(to: TWILIO_UNROUTABLE_NUMBER,
                                message: 'This is a test')
          end.to raise_error(SMS::InvalidDestinationNumber)
        end

        it 'raises an error when number is not capable of receiving sms' do
          expect do
            adaptor.send_sms(to: TWILIO_SMS_INCAPABLE_NUMBER,
                                message: 'This is a test')
          end.to raise_error(SMS::InvalidDestinationNumber)
        end
      end

      context 'configuration errors' do
        context 'invalid "From" number' do
          let(:from) { TWILIO_INVALID_NUMBER }
          it 'raises an error when twilio says that From number is invalid' do
            expect do
              adaptor.send_sms(to: TWILIO_VALID_NUMBER,
                                  message: 'This is a test')
            end.to raise_error(SMS::ServiceError)
          end
        end
      end
    end
  end
end
