# == Schema Information
#
# Table name: tracks
#
#  id             :integer          not null, primary key
#  number         :integer
#  name           :string(255)
#  video_id       :string(255)
#  conference_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  video_platform :string(255)
#

class Track < ApplicationRecord
  has_many :talks
  has_one :live_stream_ivs
  has_one :live_stream_media_live
  has_one :media_package_channel

  def on_air_talk
    on_air_talks = talks.includes(:video).map(&:video).select { |v| v && v.on_air }
    if on_air_talks.nil?
      return nil
    end
    if on_air_talks.size >= 2
      raise(Exception)
    end
    if on_air_talks.size == 0
      return nil
    end
    on_air_talks.first
  end
end
