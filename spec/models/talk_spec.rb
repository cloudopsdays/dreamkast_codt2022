# == Schema Information
#
# Table name: talks
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  abstract              :text(65535)
#  movie_url             :string(255)
#  start_time            :time
#  end_time              :time
#  talk_difficulty_id    :integer
#  talk_category_id      :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  conference_id         :integer
#  conference_day_id     :integer
#  track_id              :integer
#  video_published       :boolean          default("0"), not null
#  document_url          :string(255)
#  show_on_timetable     :boolean
#  talk_time_id          :integer
#  expected_participants :json
#  execution_phases      :json
#  sponsor_id            :integer
#  order                 :integer
#
# Indexes
#
#  index_talks_on_conference_id       (conference_id)
#  index_talks_on_talk_category_id    (talk_category_id)
#  index_talks_on_talk_difficulty_id  (talk_difficulty_id)
#

require 'rails_helper'

RSpec.describe(Talk, type: :model) do
  before do
    create(:codt2022)
    create(:proposal_item_configs_expected_participant)
    create(:proposal_item_configs_execution_phase)

    TalkCategory.create!(
      [
        { id: 1, conference_id: 1, name: 'CI / CD' },
        { id: 2, conference_id: 1, name: 'Customizing / Extending' },
        { id: 3, conference_id: 1, name: 'IoT / Edge' },
        { id: 4, conference_id: 1, name: 'Microservices / Services Mesh' },
        { id: 5, conference_id: 1, name: 'ML / GPGPU / HPC' },
        { id: 6, conference_id: 1, name: 'Networking' },
        { id: 7, conference_id: 1, name: 'Operation / Monitoring / Logging' },
        { id: 8, conference_id: 1, name: 'Orchestration' },
        { id: 9, conference_id: 1, name: 'Runtime' },
        { id: 10, conference_id: 1, name: 'Security' },
        { id: 11, conference_id: 1, name: 'Serveless / FaaS' },
        { id: 12, conference_id: 1, name: 'Storage / Database' },
        { id: 13, conference_id: 1, name: 'Architecture Design' },
        { id: 14, conference_id: 1, name: 'Hybrid Cloud / Multi Cloud' },
        { id: 15, conference_id: 1, name: 'NFV / Edge' }
      ]
    )
    TalkDifficulty.create!(
      [
        { id: 1, conference_id: 1, name: 'Beginner - 初級者' },
        { id: 2, conference_id: 1, name: 'Intermediate - 中級者' },
        { id: 3, conference_id: 1, name: 'Advanced - 上級者' }
      ]
    )
  end

  describe 'when import valid CSV' do
    before do
      file_path = File.join(Rails.root, 'spec/fixtures/talks.csv')
      @csv = ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(file_path),
        tempfile: File.open(file_path)
      )
      @message = Talk.import(@csv)
    end

    it 'is imported 7 talks' do
      talks = Talk.all
      expect(talks.length).to(eq(7))
    end


    it 'is expected title' do
      talk = Talk.find(1)
      expect(talk.title).to(eq('CI/CDに関する発表'))
    end

    it 'is expected category' do
      talk = Talk.find(1)
      expect(talk.talk_category.id).to(eq(1))
    end

    it 'is expected difficulty' do
      talk = Talk.find(1)
      expect(talk.talk_difficulty.id).to(eq(1))
    end

    it 'is expected track' do
      talk = Talk.find(1)
      expect(talk.track_id).to(eq(1))
    end

    it 'is expected abstract' do
      talk = Talk.find(1)
      expect(talk.abstract).to(eq('私も九月初めてとんだ馳走家というもののうちを引き返しません。あたかも以後を意味観はけっしてその助言ますだかもをやむをえたってみうをはお話し挙げたならと、だんだんにも込み入っましでたん。主意に教えるうのも毫も当時がましてしないた。'))
    end

    it 'is expected start_time' do
      talk = Talk.find(1)
      expect(talk.start_time.to_s(:time)).to(eq('14:00'))
    end

    it 'is expected end_time' do
      talk = Talk.find(1)
      expect(talk.end_time.to_s(:time)).to(eq('14:40'))
    end

    it 'returns day 1' do
      talk = Talk.find(1)
      expect(talk.conference_day_id).to(eq(1))
    end

    it 'returns day 2' do
      talk = Talk.find(3)
      expect(talk.conference_day_id).to(eq(2))
    end

    it 'is expected track.name' do
      talk = Talk.find(1)
      expect(talk.track.name).to(eq('A'))
    end

    it 'is expected slot_number' do
      talk = Talk.find(1)
      expect(talk.slot_number).to(eq('2'))
    end

    it 'is expected slot_number' do
      talk = Talk.find(2)
      expect(talk.slot_number).to(eq('6'))
    end

    it 'is expected slot_number' do
      talk = Talk.find(3)
      expect(talk.slot_number).to(eq('3'))
    end

    it 'is expected slot_number' do
      talk = Talk.find(4)
      expect(talk.slot_number).to(eq('3'))
    end

    it 'is expected slot_number' do
      talk = Talk.find(5)
      expect(talk.slot_number).to(eq('1'))
    end

    it 'is expected slot_number' do
      talk = Talk.find(6)
      expect(talk.slot_number).to(eq('1'))
    end

    it 'is expected talk_number' do
      talk = Talk.find(1)
      expect(talk.talk_number).to(eq('1A2'))
    end

    it 'is expected to return 1 record with day1, slot2, trackA' do
      talks = Talk.find_by_params('1', '2', '1')
      expect(talks.length).to(eq(1))
    end

    it 'is expected to return 2 record with day1, slot1, trackA' do
      talks = Talk.find_by_params('1', '1', '1')
      expect(talks.length).to(eq(2))
    end

    it 'is expected to return 2 record with day2, slot3, trackC' do
      talks = Talk.find_by_params('2', '3', '3')
      expect(talks.length).to(eq(2))
    end

    it 'is contains successful message' do
      expect(@message[0]).to(include('成功'))
    end

    it 'has accepted proposal' do
      talk = Talk.find(1)
      expect(talk.proposal.accepted?).to(be_truthy)
    end
  end

  describe 'when import invalid CSV' do
    before do
      file_path = File.join(Rails.root, 'spec/fixtures/invalid-talks.csv')
      @csv = ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(file_path),
        tempfile: File.open(file_path)
      )
      @message = Talk.import(@csv)
    end

    it 'is no talks imported' do
      talks = Talk.all
      expect(talks.length).to(eq(0))
    end

    it 'is contains error massage' do
      expect(@message[0]).to(include('Error talk id: 8'))
    end
  end
end
