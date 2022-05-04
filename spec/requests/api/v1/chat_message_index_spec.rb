require 'rails_helper'

describe Api::V1::ChatMessagesController, type: :request do
  subject(:session) {
    {
      userinfo: {
        info: {
          email: 'alice@example.com',
          extra: { sub: 'alice' }
        },
        extra: {
          raw_info: {
            sub: 'alice',
            'https://cloudnativedays.jp/roles' => roles
          }
        }
      }
    }
  }

  describe 'GET /api/v1/chat_messages' do
    before do
      allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
      create(:talk1, conference: codt2022)
      create(:message_from_alice, profile: alice)
    end

    let!(:codt2022) { create(:codt2022) }
    let!(:alice) { create(:alice, :on_codt2022, conference: codt2022) }
    let!(:roles) { '' }

    it 'succeed request' do
      get '/api/v1/chat_messages?eventAbbr=codt2022&roomId=1&roomType=talk'
      expect(response).to(have_http_status(:ok))
      expect(response.status).to(eq(200))
    end

    it 'confirm json schema' do
      get '/api/v1/chat_messages?eventAbbr=codt2022&roomId=1&roomType=talk'
      assert_response_schema_confirm
    end
  end
end
