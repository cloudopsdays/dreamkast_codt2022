require 'rails_helper'

describe EventController, type: :request do
  describe 'GET /api/v1/events/{eventId}' do
    before do
      create(:codt2022)
    end

    it 'confirm json schema' do
      get '/api/v1/events/codt2022'
      expect(response).to(have_http_status(:ok))
      assert_response_schema_confirm
    end

    it 'successed request' do
      get '/api/v1/events/codt2022'
      expect(response.status).to(eq(200))
    end
  end
end
