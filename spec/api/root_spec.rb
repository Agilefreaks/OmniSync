require 'spec_helper'

describe API::Root do
  include Rack::Test::Methods

  def app
    OmniSync::App.instance
  end

  # rubocop:disable Blocks
  let(:options) {
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  }

  describe 'POST /notify' do
    subject { post '/api/v1/notify', params.to_json, options }

    let(:params) { { registration_ids: %w(42 43), data: { provider: 'clipboard' }.to_json } }

    context 'when there is a client' do
      let(:client) { double(:client) }

      before do
        allow_any_instance_of(WAMP::Engines::Memory).to receive(:clients).and_return('42' => client, '43' => client)
      end

      it 'calls create_event' do
        expect_any_instance_of(WAMP::Engines::Memory).to receive(:create_event)
                                                         .with(client, '42', params[:data], false, nil)
        expect_any_instance_of(WAMP::Engines::Memory).to receive(:create_event)
                                                         .with(client, '43', params[:data], false, nil)
        expect(OmniSync::App.instance).to receive(:trigger).with(:publish, client, '42', params[:data], false, nil)
        expect(OmniSync::App.instance).to receive(:trigger).with(:publish, client, '43', params[:data], false, nil)

        subject

        expect(last_response.status).to eq 201
        expect(last_response.body).to eq API::Entities::Notification.new(
                                             OpenStruct.new(number_of_send_notifications: 2)
                                         ).to_json
      end
    end
  end
end
