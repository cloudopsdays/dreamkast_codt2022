require 'rails_helper'

RSpec.describe(TalksController, type: :controller) do
  describe 'display_video?' do
    let!(:category) { create(:talk_category1, conference: conference) }
    let!(:difficulty) { create(:talk_difficulties1, conference: conference) }
    let!(:talk1) { create(:talk1, conference: conference) }

    shared_examples_for :display_video_method_returns do |bool|
      it "display_video? returns #{bool}" do
        controller = TalksController.new
        expect(controller.display_video?(talk1)).to(bool ? be_truthy : be_falsey)
      end
    end

    shared_examples_for :video_is_published_and_present_and_archived do |bool|
      context 'talk is video_published, video is present and talk is archived' do
        before do
          allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
        end
        let!(:talk1) { create(:talk1, :video_published, conference: conference) }
        let!(:video) { create(:video) }

        it_should_behave_like :display_video_method_returns, bool
      end
    end

    shared_examples_for :video_is_not_published do |bool|
      context "video isn't published" do
        before do
          allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
        end
        let!(:talk1) { create(:talk1, :video_not_published, conference: conference) }
        let!(:video) { create(:video) }

        it_should_behave_like :display_video_method_returns, bool
      end
    end

    shared_examples_for :video_is_not_present do |bool|
      context "video isn't present" do
        before do
          allow_any_instance_of(Talk).to(receive(:archived?).and_return(true))
        end
        let!(:talk1) { create(:talk1, :video_not_published, conference: conference) }

        it_should_behave_like :display_video_method_returns, bool
      end
    end

    shared_examples_for :video_is_not_archived do |bool|
      context "talk isn't archived" do
        before do
          allow_any_instance_of(Talk).to(receive(:archived?).and_return(false))
        end
        let!(:talk1) { create(:talk1, :video_published, conference: conference) }

        it_should_behave_like :display_video_method_returns, bool
      end
    end

    context 'user logged in' do
      before do
        allow_any_instance_of(TalksController).to(receive(:logged_in?).and_return(true))
      end

      context 'conference is registered' do
        let!(:conference) { create(:codt2022, :registered) }

        it_should_behave_like :video_is_published_and_present_and_archived, false
        it_should_behave_like :video_is_not_present, false
      end

      context 'conference is opened' do
        let!(:conference) { create(:codt2022, :opened) }

        it_should_behave_like :video_is_published_and_present_and_archived, true
        it_should_behave_like :video_is_not_present, false
      end

      context 'conference is closed' do
        let!(:conference) { create(:codt2022, :closed) }

        it_should_behave_like :video_is_published_and_present_and_archived, true
        it_should_behave_like :video_is_not_present, false
      end

      context 'conference is archived' do
        let!(:conference) { create(:codt2022, :archived) }

        it_should_behave_like :video_is_published_and_present_and_archived, true
        it_should_behave_like :video_is_not_present, false
      end

      context 'conference is video_enabled' do
        let!(:conference) { create(:codt2022, :video_enabled) }

        it_should_behave_like :video_is_published_and_present_and_archived, true
        it_should_behave_like :video_is_not_present, false
      end
    end

    context "user doesn't logged in" do
      before do
        allow_any_instance_of(TalksController).to(receive(:logged_in?).and_return(false))
      end

      context 'conference is registered' do
        let!(:conference) { create(:codt2022, :registered) }

        it_should_behave_like :video_is_published_and_present_and_archived, false
        it_should_behave_like :video_is_not_present, false
      end

      context 'conference is opened' do
        let!(:conference) { create(:codt2022, :opened) }

        it_should_behave_like :video_is_published_and_present_and_archived, false
        it_should_behave_like :video_is_not_present, false
      end

      context 'conference is closed' do
        let!(:conference) { create(:codt2022, :closed) }

        it_should_behave_like :video_is_published_and_present_and_archived, false
        it_should_behave_like :video_is_not_present, false
      end

      context 'conference is archived' do
        let!(:conference) { create(:codt2022, :archived) }

        it_should_behave_like :video_is_published_and_present_and_archived, true
        it_should_behave_like :video_is_not_present, false
      end

      context 'conference is video_enabled' do
        let!(:conference) { create(:codt2022, :video_enabled) }

        it_should_behave_like :video_is_published_and_present_and_archived, false
        it_should_behave_like :video_is_not_present, false
      end
    end
  end
end
