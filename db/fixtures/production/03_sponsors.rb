Sponsor.seed(
  {
    id: 1,
    name: "New Relic 株式会社",
    abbr: "newrelic",
    conference_id: 1,
    url: ""
  },
  {
    id: 2,
    name: "F5ネットワークスジャパン合同会社",
    abbr: "f5",
    conference_id: 1,
    url: ""
  },
  {
    id: 3,
    name: "株式会社フィックスポイント",
    abbr: "fixpoint",
    conference_id: 1,
    url: ""
  },
  {
    id: 4,
    name: "インテル株式会社",
    abbr: "intel",
    conference_id: 1,
    url: ""
  },
  {
    id: 5,
    name: "ヴイエムウェア株式会社",
    abbr: "vmware",
    conference_id: 1,
    url: ""
  },
  {
    id: 6,
    name: "PagerDuty",
    abbr: "pagerduty",
    conference_id: 1,
    url: ""
  },
  {
    id: 7,
    name: "日本マイクロソフト株式会社",
    abbr: "microsoft",
    conference_id: 1,
    url: ""
  },
  {
    id: 8,
    name: "OpsRamp, Inc.",
    abbr: "opsramp",
    conference_id: 1,
    url: ""
  },
  {
    id: 9,
    name: "NTTデータ先端技術株式会社",
    abbr: "nttdata",
    conference_id: 1,
    url: ""
  },
  {
    id: 10,
    name: "日本ヒューレット・パッカード合同会社",
    abbr: "hpe",
    conference_id: 1,
    url: ""
  },
  {
    id: 11,
    name: "株式会社カサレアル",
    abbr: "casareal",
    conference_id: 1,
    url: ""
  },
  {
    id: 12,
    name: "LINE株式会社",
    abbr: "line",
    conference_id: 1,
    url: ""
  },
  {
    id: 13,
    name: "Canonical / Ubuntu",
    abbr: "canonical",
    conference_id: 1,
    url: ""
  },
  {
    id: 14,
    name: "AXLBIT株式会社",
    abbr: "axlbit",
    conference_id: 1,
    url: ""
  },
  {
    id: 15,
    name: "OpenInfra Foundation",
    abbr: "openinfra",
    conference_id: 1,
    url: ""
  },
  {
    id: 16,
    name: "ヤフー株式会社",
    abbr: "yahoo",
    conference_id: 1,
    url: ""
  },
  {
    id: 17,
    name: "株式会社ハートビーツ",
    abbr: "heartbeats",
    conference_id: 1,
    url: ""
  },
  {
    id: 18,
    name: "ジュニパーネットワークス株式会社",
    abbr: "juniper",
    conference_id: 1,
    url: ""
  },
  {
    id: 19,
    name: "東日本電信電話株式会社",
    abbr: "ntte",
    conference_id: 1,
    url: ""
  },
  {
    id: 20,
    name: "株式会社デンソー",
    abbr: "denso",
    conference_id: 1,
    url: ""
  },
  {
    id: 21,
    name: "富士通株式会社",
    abbr: "fujitsu",
    conference_id: 1,
    url: ""
  },
  {
    id: 22,
    name: "株式会社プレイド",
    abbr: "plaid",
    conference_id: 1,
    url: ""
  },
)

SponsorType.seed(
  { id: 1,
    conference_id: 1,
    name: "Diamond",
    order: 1,
  },
  { id: 2,
    conference_id: 1,
    name: "Platinum",
    order: 2,
  },
  { id: 3,
    conference_id: 1,
    name: "Gold",
    order: 3,
  },
  { id: 4,
    conference_id: 1,
    name: "Silver",
    order: 4,
  },
  { id: 5,
    conference_id: 1,
    name: "Tool",
    order: 5,
  },
)

[
  [1, 'Diamond', 'newrelic', 1],
  [2, 'Diamond', 'f5', 1],
  [3, 'Diamond', 'fixpoint', 1],
  [4, 'Diamond', 'intel', 1],
  [5, 'Diamond', 'vmware', 1],
  [6, 'Platinum', 'pagerduty', 1],
  [7, 'Platinum', 'microsoft', 1],
  [8, 'Platinum', 'opsramp', 1],
  [9, 'Platinum', 'nttdata', 1],
  [10, 'Gold', 'hpe', 1],
  [11, 'Gold', 'casareal', 1],
  [12, 'Gold', 'line', 1],
  [13, 'Gold', 'canonical', 1],
  [14, 'Gold', 'axlbit', 1],
  [15, 'Gold', 'openinfra', 1],
  [16, 'Gold', 'yahoo', 1],
  [17, 'Gold', 'heartbeats', 1],
  [18, 'Gold', 'juniper', 1],
  [19, 'Gold', 'nttw', 1],
  [20, 'Silver', 'denso', 1],
  [21, 'Silver', 'fujitsu', 1],
  [22, 'Tool', 'plaid', 1],
].each do |sponsors_sponsor_type|
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

[
  [1, 'newrelic', 'sponsors/codt2022/newrelic.png', 1],
  [2, 'f5', 'sponsors/codt2022/f5.png', 1],
  [3, 'fixpoint', 'sponsors/codt2022/fixpoint.png', 1],
  [4, 'intel', 'sponsors/codt2022/intel.png', 1],
  [5, 'vmware', 'sponsors/codt2022/vmware.png', 1],
  [6, 'pagerduty', 'sponsors/codt2022/pagerduty.png', 1],
  [7, 'microsoft', 'sponsors/codt2022/microsoft.png', 1],
  [8, 'opsramp', 'sponsors/codt2022/opsramp.png', 1],
  [9, 'nttdata', 'sponsors/codt2022/nttdata.png', 1],
  [10, 'hpe', 'sponsors/codt2022/hpe.png', 1],
  [11, 'casareal', 'sponsors/codt2022/casareal.png', 1],
  [12, 'line', 'sponsors/codt2022/line.png', 1],
  [13, 'canonical', 'sponsors/codt2022/canonical.png', 1],
  [14, 'axlbit', 'sponsors/codt2022/axlbit.png', 1],
  [15, 'openinfra', 'sponsors/codt2022/openinfra.png', 1],
  [16, 'yahoo', 'sponsors/codt2022/yahoo.png', 1],
  [17, 'heartbeats', 'sponsors/codt2022/heartbeats.png', 1],
  [18, 'juniper', 'sponsors/codt2022/juniper.png', 1],
  [19, 'nttw', 'sponsors/codt2022/nttw.png', 1],
  [20, 'denso', 'sponsors/codt2022/denso.png', 1],
  [21, 'fujitsu', 'sponsors/codt2022/fujitsu.png', 1],
  [22, 'plaid', 'sponsors/codt2022/plaid.png', 1],
].each do |logo|
  SponsorAttachment.seed(
    { id: logo[0],
      sponsor_id: Sponsor.find_by(abbr: logo[1], conference_id: logo[3]).id,
      type: 'SponsorAttachmentLogoImage',
      url: logo[2]
    }
  )
end
