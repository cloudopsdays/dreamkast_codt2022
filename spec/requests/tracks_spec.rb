require 'rails_helper'

RSpec.describe(TracksController, type: :request) do
  subject { get '/codt2022/dashboard' }
  let!(:session) { { userinfo: { info: { email: 'alice@example.com', extra: { sub: 'aaa' } }, extra: { raw_info: { sub: 'aaa', 'https://cloudnativedays.jp/roles' => roles } } } } }
  let(:roles) { [] }

  describe 'GET /:event/dashboard' do
    describe 'logged in and registered but doesnt register any talks' do
      before do
        create(:codt2022)
        create(:alice, :on_codt2022)
        allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
      end

      context 'access to dashboard' do
        it 'redirect to timetable' do
          subject
          expect(response).to_not(be_successful)
          expect(response).to(redirect_to('/codt2022/timetables'))
        end
      end
    end

    describe 'logged in and registered and register 1 talks' do
      before do
        create(:codt2022)
        create(:alice, :on_codt2022)
        create(:talk1)
        create(:alice_talk1)
        allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
      end

      context 'user is admin' do
        let(:roles) { ['CODT2022-Admin'] }

        it 'return a success response' do
          subject
          expect(response).to(be_successful)
          expect(response).to(have_http_status('200'))
        end

        it 'link to admin is displayed' do
          subject
          expect(response.body).to(include('<a class="dropdown-item" href="/codt2022/admin">管理画面</a>'))
        end

        context 'user is not speaker' do
          it 'not show speaker_announcements' do
            subject
            expect(response).to(be_successful)
            expect(response.body).not_to(include('<h4>Alice様へのお知らせ</h4>'))
          end
        end
      end

      context 'user is not admin' do
        it 'return a success response' do
          subject
          expect(response).to(be_successful)
          expect(response).to(have_http_status('200'))
        end

        it 'link to admin is not displayed' do
          subject
          expect(response.body).to_not(include('<a class="dropdown-item" href="/admin">管理画面</a>'))
        end
      end

      context "get not exists event's dashboard" do
        it 'returns not found response' do
          get '/not_found/dashboard'
          expect(response).to_not(be_successful)
          expect(response).to(have_http_status('404'))
        end
      end
    end

    describe 'not logged in' do
      before do
        create(:codt2022)
      end

      context "get exists event's dashboard" do
        it 'redirect to top page a success response' do
          subject
          expect(response).to_not(be_successful)
          expect(response).to(have_http_status('302'))
          expect(response).to(redirect_to('/codt2022'))
        end
      end

      context "get not exists event's dashboard" do
        it 'redirect to top page a success response' do
          get '/not_found/dashboard'
          expect(response).to_not(be_successful)
          expect(response).to(have_http_status('404'))
        end
      end
    end
  end

  describe 'GET /:event/tracks' do
    describe 'logged in and registered' do
      before do
        create(:codt2022, :opened)
        create(:alice, :on_codt2022)
        allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
      end

      context 'when user access to dashboard' do
        it 'return a success response' do
          get '/codt2022/tracks'
          expect(response).to_not(be_successful)
          expect(response).to(have_http_status('302'))
          expect(response).to(redirect_to('/codt2022/ui/'))
        end
      end

      context 'when user access to root page' do
        it 'redirect to tracks' do
          get '/codt2022'
          expect(response).to_not(be_successful)
          expect(response).to(have_http_status('302'))
          expect(response).to(redirect_to('/codt2022/dashboard'))
        end
      end
    end

    describe 'not logged in' do
      before do
        create(:codt2022)
      end

      context "get exists event's dashboard" do
        it 'redirect to top page a success response' do
          get '/codt2022/tracks'
          expect(response).to_not(be_successful)
          expect(response).to(have_http_status('302'))
          expect(response).to(redirect_to('/codt2022'))
        end
      end
    end
  end
end
