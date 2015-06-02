require 'spec_helper'

describe API::Root do
  include Rack::Test::Methods

  def app
    OmniSync::App.instance
  end

  # rubocop:disable Blocks
  let(:options) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
      'HTTP_WS_SYNCTOKEN' => '0142'
    }
  end

  describe 'POST /notify' do
    subject { post '/api/v1/notify', params.to_json, options }

    let(:params) { { data: { provider: 'clipboard' }.to_json } }

    context 'when there is a client' do
      let(:client) { double(:client) }

      before do
        allow_any_instance_of(WAMP::Engines::Omni).to receive(:clients).and_return('0142' => client)
      end

      it 'calls create_event' do
        expect_any_instance_of(WAMP::Engines::Omni).to receive(:create_event)
          .with(client, '0142', params[:data], false, nil)
        expect(OmniSync::App.instance).to receive(:trigger).with(:publish, client, '0142', params[:data], false, nil)

        subject

        expect(last_response.status).to eq 201
        expect(last_response.body).to eq API::Entities::Notification.new(
          OpenStruct.new(number_of_send_notifications: 1)
        ).to_json
      end
    end
  end
end
