require 'rails_helper'

describe DreamkastExporter, type: :request do
  context 'GET /metrics' do
    before do
      create(:talk1, conference: codt2022)
      create(:talk3, conference: codt2022)
      create_list(:messages, 10, :alice, :roomid1, profile: alice)
      create_list(:messages, 12, :bob, :roomid2, profile: bob)
      create_list(:viewer_count, 3, :talk1)
      create_list(:viewer_count, 3, :talk3)
      create(:video, :on_air, :talk1)
      create(:video, :on_air, :talk3)
    end
    after(:each) do
      FactoryBot.rewind_sequences
    end

    let!(:codt2022) { create(:codt2022, :opened) }
    let!(:alice) { create(:alice, :on_codt2022, conference: codt2022) }
    let!(:bob) { create(:bob, :on_codt2022, conference: codt2022) }

    it 'returns a success response with event top page' do
      get '/metrics'
      expect(response).to(be_successful)
      expect(response).to(have_http_status('200'))
      expect(response.body).to(include('dreamkast_viewer_count{talk_id="1",track_id="1",conference_id="1"} 3.0'))
      expect(response.body).to(include('dreamkast_chat_count{conference_id="1",talk_id="2"} 12.0'))
    end

    context 'have multiple profiles in each conference' do
      let!(:o11y2022) { create(:o11y2022, :registered) }
      let!(:alice) { create(:alice, :on_o11y2022, conference: o11y2022) }
      let!(:bob) { create(:bob, :on_codt2022, conference: codt2022) }
      it 'returns a number of regisrants each conferences' do
        get '/metrics'
        expect(response.body).to(include('dreamkast_registrants_count{conference_id="1"} 1.0'))
        expect(response.body).to(include('dreamkast_registrants_count{conference_id="2"} 1.0'))
      end
    end
  end
end
