json.array! @talks do |talk|
  json.id talk.id
  json.trackId talk.track_id
  json.videoPlatform "foo"
  json.videoId "foo"
  json.title talk.title
  json.abstract talk.abstract
  json.speakers talk.speaker_ids
  json.dayId talk.conference_day.id
  json.showOnTimetable talk.show_on_timetable
  json.startTime talk.start_time
  json.endTime talk.end_time
  json.talkDuration talk.duration
  json.talkDifficulty talk.difficulty
  json.talkCategory talk.category
  json.onAir talk.on_air?
  json.documentUrl talk.document_url
end
