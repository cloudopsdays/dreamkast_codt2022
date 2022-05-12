require 'rails_helper'

describe EventController, type: :request do
  subject(:session) { { userinfo: { info: { email: 'alice@example.com' }, extra: { raw_info: { sub: 'aaaa', 'https://cloudnativedays.jp/roles' => roles } } } } }
  let(:roles) { [] }

  describe 'GET event#show' do
    before do
      create(:codt2022)
    end

    context 'not logged in' do
      it 'returns a success response with event top page' do
        get '/codt2022'
        expect(response).to(have_http_status('302'))
        expect(response).to(redirect_to('https://cloudopsdays.com/'))
      end

      it 'returns a success response with privacy policy' do
        get '/codt2022/privacy'
        expect(response).to(be_successful)
        expect(response).to(have_http_status('200'))
        expect(response.body).to(include('This is Privacy Policy'))
      end

      it 'returns a success response with code of conduct' do
        get '/codt2022/coc'
        expect(response).to(be_successful)
        expect(response).to(have_http_status('200'))
        expect(response.body).to(include('行動規範'))
      end
    end

    context 'when logged in and speaker_entry is enabled' do
      context 'not registered' do
        before do
          allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
        end

        it 'returns a success response with event top page' do
          get '/codt2022'
          expect(response).to(have_http_status('302'))
          expect(response).to(redirect_to('https://cloudopsdays.com/'))
        end
      end

      context 'registered' do
        before do
          allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
          create(:speaker_alice)
        end

        it 'returns a success response with event top page' do
          get '/codt2022'
          expect(response).to(have_http_status('302'))
          expect(response).to(redirect_to('https://cloudopsdays.com/'))
        end
      end
    end
  end

  describe 'logged in and speaker_entry is disabled' do
    before do
      create(:codt2022, :speaker_entry_disabled)
    end

    context 'not registered' do
      before do
        allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
      end

      it 'returns a success response with event top page' do
        get '/codt2022'
        expect(response).to_not(be_successful)
        expect(response).to(have_http_status('302'))
        expect(response).to(redirect_to('/codt2022/dashboard'))
      end
    end

    context 'registered' do
      before do
        allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
        create(:speaker_alice)
      end

      it 'returns a success response with event top page' do
        get '/codt2022'
        expect(response).to_not(be_successful)
        expect(response).to(have_http_status('302'))
        expect(response).to(redirect_to('/codt2022/dashboard'))
      end
    end
  end
end
