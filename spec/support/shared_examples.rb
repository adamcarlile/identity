# frozen_string_literal: true

RSpec.shared_examples :sms_service_error_handler do
  include_context :sms_transport, mocked: false
  let(:mobile_number) { international_phone_number }

  it 'returns status code 500' do
    expect(response.status).to eq(500)
  end

  it 'returns an error' do
    expected_payload = {
      "id": '500',
      "message": 'Unable to complete request',
      "type": 'api_error'
    }

    expected = JSON(response.body, symbolize_names: true)
    expect(expected).to eq(expected_payload)
  end

  # TODO: can't assert on 500 errors because rails modifies path_info
  # which confuses committee on where to look for definition in schema
  # It expects a path /500 to be declared because rails mods path_info
  # to '/<status_code>' style paths for exceptions.
  # We can check schema compliance once committee address this:
  # https://github.com/interagent/committee/issues/229
  #
  # it_behaves_like :a_schema_compliant_service
end

RSpec.shared_examples :a_schema_compliant_service do
  include Committee::Rails::Test::Methods

  specify '(assert that schema conforms)' do
    assert_schema_conform
  end
end
