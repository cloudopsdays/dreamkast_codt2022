Sponsor.seed()

SponsorType.seed()

[].each do |sponsors_sponsor_type|
  id = sponsors_sponsor_type[0]
  sponsor_type = SponsorType.find_by(name: sponsors_sponsor_type[1], conference_id: sponsors_sponsor_type[3])
  sponsor = Sponsor.find_by(abbr: sponsors_sponsor_type[2], conference_id: sponsors_sponsor_type[3])
  SponsorsSponsorType.seed({id: id, sponsor_type_id: sponsor_type.id, sponsor_id: sponsor.id})
  if sponsors_sponsor_type[1] == 'Booth'
    Booth.seed(:conference_id, :sponsor_id) do |s|
      s.conference_id = sponsors_sponsor_type[3]
      s.sponsor_id = sponsor.id
    end
  end
end

[].each do |logo|
  SponsorAttachment.seed(
    { id: logo[0],
      sponsor_id: Sponsor.find_by(abbr: logo[1], conference_id: logo[3]).id,
      type: 'SponsorAttachmentLogoImage',
      url: logo[2]
    }
  )
end

SponsorAttachment.seed()
