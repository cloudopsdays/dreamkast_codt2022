require "aws-sdk-medialive"

class StopRecordingJob < ApplicationJob
  include LogoutHelper

  queue_as :default
  self.queue_adapter = :async

  def perform(*args)
    talk = args[0]
    logger.info "Perform StopRecordingJob: talk_id=#{talk.id}"
    talk.track.live_stream_media_live.stop_recording

    talk.video.update!(site: 's3', video_id: talk.track.live_stream_media_live.playback_url)

    payload = {
      event: 'channel_stopped',
      channel_id: talk.track.live_stream_media_live.channel_id,
      track_name: talk.track.name,
      talk_id: talk.id
    }
    ActionCable.server.broadcast("recording_channel", payload)
  rescue => e
    logger.error e.message
  end
end
