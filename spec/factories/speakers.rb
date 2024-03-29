# == Schema Information
#
# Table name: speakers
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  profile              :text(65535)
#  company              :string(255)
#  job_title            :string(255)
#  twitter_id           :string(255)
#  github_id            :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  avatar_data          :text(65535)
#  conference_id        :integer
#  email                :text(65535)
#  sub                  :text(65535)
#  additional_documents :text(65535)
#  name_mother_tongue   :string(255)
#

FactoryBot.define do
  factory :speaker_alice, class: Speaker do
    id { 1 }
    sub { 'aaa' }
    email { 'alice@example.com' }
    name { 'Alice' }
    profile { 'This is profile' }
    company { 'company' }
    job_title { 'job_title' }
    conference_id { 1 }

    trait :with_talk1_registered do
      after(:build) do |speaker|
        talk = FactoryBot.create(:talk1)
        speaker.talks << talk
        FactoryBot.create(:talks_speakers, { talk: talk, speaker: speaker })
        proposal = FactoryBot.create(:proposal, :with_cndt2021, talk: talk, status: 0)
      end
    end

    trait :with_talk1_accepted do
      after(:build) do |speaker|
        talk = FactoryBot.create(:talk1)
        speaker.talks << talk
        FactoryBot.create(:talks_speakers, { talk: talk, speaker: speaker })
        proposal = FactoryBot.create(:proposal, :with_cndt2021, talk: talk, status: 1)
      end
    end

    trait :with_talk1_rejected do
      after(:build) do |speaker|
        talk = FactoryBot.create(:talk1)
        speaker.talks << talk
        FactoryBot.create(:talks_speakers, { talk: talk, speaker: speaker })
        proposal = FactoryBot.create(:proposal, :with_cndt2021, talk: talk, status: 2)
      end
    end

    trait :with_sponsor_session do
      after(:build) do |speaker|
        sponsor = create(:sponsor)
        talk = create(:sponsor_session, sponsor: sponsor)
        speaker.talks << talk
        create(:talks_speakers, { talk: talk, speaker: speaker })
        create(:proposal, :with_cndt2021, talk: talk, status: 0)
      end
    end
  end

  factory :talks_speakers, class: TalksSpeaker

  factory :speaker_bob, class: Speaker do
    id { 2 }
    sub { 'bbb' }
    email { 'bar@example.com' }
    name { 'Bob' }
    profile { 'This is profile' }
    company { 'company' }
    job_title { 'job_title' }
    conference_id { 1 }
  end

  factory :speaker_mike, class: Speaker do
    id { 3 }
    sub { 'github' }
    email { 'mike@example.com' }
    name { 'Mike' }
    profile { 'This is profile' }
    company { 'company' }
    job_title { 'job_title' }
    conference_id { 1 }

    trait :with_speaker_announcement do
      id { 4 }
      after(:build) do |speaker|
        speaker_announcement = FactoryBot.create(:speaker_announcement, :published)
        speaker.speaker_announcements << speaker_announcement
        FactoryBot.create(:speaker_announcement_middle, { speaker: speaker, speaker_announcement: speaker_announcement })
      end
    end
  end
end
