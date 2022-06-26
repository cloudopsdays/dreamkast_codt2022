require 'rails_helper'

describe TalksController, type: :request do
  subject(:session) { { userinfo: { info: { email: 'alice@example.com', extra: { sub: 'aaa' } }, extra: { raw_info: { sub: 'aaa', 'https://cloudnativedays.jp/roles' => roles } } } } }
  let(:roles) { [] }

  describe 'GET /codt2022/talks/:id' do
    context 'codt2022 is registered' do
      before do
        create(:codt2022, :registered)
        create(:talk_category1)
        create(:talk_difficulties1)
      end
      let!(:talk1) { create(:talk1) }
      let!(:talk2) { create(:talk2) }
      let!(:video) { create(:video) }

      context "user doesn't logged in" do
        it 'returns a success response' do
          get '/codt2022/talks/1'
          expect(response).to(be_successful)
          expect(response).to(have_http_status('200'))
          expect(response.body).to(include(talk1.abstract))
          expect(response.body).to(include(talk1.title))
        end

        it "doesn't includes vimeo iframe" do
          get '/codt2022/talks/1'
          expect(response).to(be_successful)
          expect(response.body).not_to(include('player.vimeo.com'))
        end

        it "doesn't includes slido iframe" do
          get '/codt2022/talks/1'
          expect(response).to(be_successful)
          expect(response.body).not_to(include('sli.do'))
        end
      end

      context 'user logged in' do
        context "user doesn't registered" do
          before do
            allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return({ info: { email: 'alice@example.com' } }))
          end

          it 'redirect to /codt2022/registration' do
            get '/codt2022/talks/1'
            expect(response).to_not(be_successful)
            expect(response).to(have_http_status('302'))
            expect(response).to(redirect_to('/codt2022/registration'))
          end
        end

        context 'user already registered' do
          before do
            create(:alice, :on_codt2022)
            allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
          end

          it 'returns a success response with form' do
            get '/codt2022/talks/2'
            expect(response).to(be_successful)
            expect(response).to(have_http_status('200'))
            expect(response.body).to(include('タイムテーブル'))
            expect(response.body).to(include(talk2.title))
          end

          it 'includes slido iframe if it has slido id' do
            get '/codt2022/talks/1'
            expect(response).to(be_successful)
            expect(response.body).to(include('sli.do'))
          end

          it 'includes twitter iframe if it not have slido id' do
            get '/codt2022/talks/2'
            expect(response).to(be_successful)
            expect(response.body).to(include('twitter-timeline'))
          end

          context 'talk is archived' do
            before do
              allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
            end

            it 'includes vimeo iframe' do
              get '/codt2022/talks/1'
              expect(response).to(be_successful)
              expect(response.body).not_to(include('player.vimeo.com'))
            end
          end

          context 'talk is not archived' do
            before do
              allow_any_instance_of(Talk).to(receive(:archived?).and_return(false))
            end

            it 'includes vimeo iframe' do
              get '/codt2022/talks/1'
              expect(response).to(be_successful)
              expect(response.body).not_to(include('player.vimeo.com'))
            end
          end
        end
      end
    end

    context 'codt2022 is opened' do
      before do
        create(:codt2022, :opened)
        create(:talk_category1)
        create(:talk_difficulties1)
      end
      let!(:talk1) { create(:talk1) }
      let!(:talk2) { create(:talk2) }
      let!(:video) { create(:video) }

      context "user doesn't logged in" do
        context 'talk is archived' do
          before do
            allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
          end

          it "doesn't includes vimeo iframe" do
            get '/codt2022/talks/1'
            expect(response).to(be_successful)
            expect(response.body).not_to(include('player.vimeo.com'))
          end
        end

        context 'talk is not archived' do
          before do
            allow_any_instance_of(Talk).to(receive(:archived?).and_return(false))
          end

          it "doesn't includes vimeo iframe" do
            get '/codt2022/talks/1'
            expect(response).to(be_successful)
            expect(response.body).not_to(include('player.vimeo.com'))
          end
        end
      end

      context 'user logged in' do
        context 'user already registered' do
          before do
            create(:o11y2022)
            create(:alice, :on_codt2022)
            create(:alice, :on_o11y2022)
            allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
            allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
          end

          it ' includes vimeo iframe if video_published is true' do
            get '/codt2022/talks/1'
            expect(response).to(be_successful)
            expect(response.body).to(include('player.vimeo.com'))
          end

          it "doesn't includes vimeo iframe if video_published is false" do
            get '/codt2022/talks/2'
            expect(response).to(be_successful)
            expect(response.body).not_to(include('player.vimeo.com'))
          end

          it 'return 404 when you try to show talk that is not included conference' do
            get '/o11y2022/talks/1'
            expect(response).to_not(be_successful)
            expect(response).to(have_http_status('404'))
          end

          context 'talk is archived' do
            before do
              allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
            end

            it 'includes vimeo iframe' do
              get '/codt2022/talks/1'
              expect(response).to(be_successful)
              expect(response.body).to(include('player.vimeo.com'))
            end
          end
        end
      end
    end

    context 'codt2022 is closed' do
      before do
        create(:codt2022, :closed)
        create(:talk_category1)
        create(:talk_difficulties1)
      end
      let!(:talk1) { create(:talk1) }
      let!(:talk2) { create(:talk2) }
      let!(:video) { create(:video) }

      context "user doesn't logged in" do
        describe 'talk is archived' do
          before do
            allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
          end

          it 'includes vimeo iframe' do
            get '/codt2022/talks/1'
            expect(response).to(be_successful)
            expect(response.body).to_not(include('player.vimeo.com'))
          end
        end

        context 'talk is not archived' do
          before do
            allow_any_instance_of(Talk).to(receive(:archived?).and_return(false))
          end

          it "doesn't includes vimeo iframe" do
            get '/codt2022/talks/1'
            expect(response).to(be_successful)
            expect(response.body).to_not(include('player.vimeo.com'))
          end
        end
      end

      context 'user logged in' do
        context 'user already registered' do
          before do
            create(:o11y2022)
            create(:alice, :on_codt2022)
            create(:alice, :on_o11y2022)
            allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
            allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
          end

          it ' includes vimeo iframe if video_published is true' do
            get '/codt2022/talks/1'
            expect(response).to(be_successful)
            expect(response.body).to(include('player.vimeo.com'))
          end

          it "doesn't includes vimeo iframe if video_published is false" do
            get '/codt2022/talks/2'
            expect(response).to(be_successful)
            expect(response.body).not_to(include('player.vimeo.com'))
          end

          it 'return 404 when you try to show talk that is not included conference' do
            get '/o11y2022/talks/1'
            expect(response).to_not(be_successful)
            expect(response).to(have_http_status('404'))
          end

          context 'talk is archived' do
            before do
              allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
            end

            it 'includes vimeo iframe' do
              get '/codt2022/talks/1'
              expect(response).to(be_successful)
              expect(response.body).to(include('player.vimeo.com'))
            end
          end
        end
      end
    end

    context 'codt2022 is archived' do
      before do
        create(:codt2022, :archived)
        create(:talk_category1)
        create(:talk_difficulties1)
      end
      let!(:talk1) { create(:talk1) }
      let!(:talk2) { create(:talk2) }
      let!(:video) { create(:video) }

      context "user doesn't logged in" do
        context 'talk is archived' do
          before do
            allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
          end

          it 'includes vimeo iframe' do
            get '/codt2022/talks/1'
            expect(response).to(be_successful)
            expect(response.body).to(include('player.vimeo.com'))
          end
        end
      end

      context 'user logged in' do
        context 'user already registered' do
          before do
            create(:o11y2022)
            create(:alice, :on_codt2022)
            create(:alice, :on_o11y2022)
            allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
            allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
          end

          it ' includes vimeo iframe if video_published is true' do
            get '/codt2022/talks/1'
            expect(response).to(be_successful)
            expect(response.body).to(include('player.vimeo.com'))
          end

          it "doesn't includes vimeo iframe if video_published is false" do
            get '/codt2022/talks/2'
            expect(response).to(be_successful)
            expect(response.body).not_to(include('player.vimeo.com'))
          end

          it 'return 404 when you try to show talk that is not included conference' do
            get '/o11y2022/talks/1'
            expect(response).to_not(be_successful)
            expect(response).to(have_http_status('404'))
          end

          context 'talk is archived' do
            before do
              allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
            end

            it 'includes vimeo iframe' do
              get '/codt2022/talks/1'
              expect(response).to(be_successful)
              expect(response.body).to(include('player.vimeo.com'))
            end
          end
        end
      end
    end
  end

  describe 'GET /codt2022/talks' do
    let!(:userinfo) { { userinfo: { info: { email: 'alice@example.com' }, extra: { raw_info: { 'https://cloudnativedays.jp/roles' => 'CODT2022-Admin', sub: '' } } } } }

    context 'codt2022 is registered' do
      before { create(:codt2022, :registered) }

      context "user doesn't logged in" do
        it 'returns a success response' do
          get '/codt2022/talks'
          expect(response).to(be_successful)
        end
      end

      context "user doesn't registered" do
        before {
          allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
        }
        it 'redirect to /codt2022/registration' do
          get '/codt2022/talks'
          expect(response).to_not(be_successful)
          expect(response).to(have_http_status('302'))
          expect(response).to(redirect_to('/codt2022/registration'))
        end

        context 'when user is registered as speaker' do
          before { create(:speaker_alice) }
          it 'returns a success response' do
            get '/codt2022/talks'
            expect(response).to(be_successful)
          end
        end
      end
    end

    context 'codt2022 is opened' do
      before  { create(:codt2022, :opened) }
      context "user doesn't registered" do
        before {
          allow_any_instance_of(ActionDispatch::Request::Session).to(receive(:[]).and_return(session[:userinfo]))
        }
        it 'redirect to /codt2022/registration' do
          get '/codt2022/talks'
          expect(response).to_not(be_successful)
          expect(response).to(have_http_status('302'))
          expect(response).to(redirect_to('/codt2022/registration'))
        end

        context 'when user is registered as speaker' do
          before { create(:speaker_alice) }
          it 'redirect to /codt2022/registration' do
            get '/codt2022/talks'
            expect(response).to_not(be_successful)
            expect(response).to(have_http_status('302'))
            expect(response).to(redirect_to('/codt2022/registration'))
          end
        end
      end
    end
  end
end
