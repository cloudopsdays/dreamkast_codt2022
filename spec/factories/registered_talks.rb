# == Schema Information
#
# Table name: registered_talks
#
#  id         :integer          not null, primary key
#  profile_id :integer
#  talk_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :alice_talk1, class: RegisteredTalk do
    profile_id { 1 }
    talk_id { 1 }
  end
end
