Conference.seed(
  {
    id: 1,
    name: 'Cloud Operator Days Tokyo 2022',
    abbr: 'codt2022',
    theme: '運用者に光を！〜変革への挑戦〜',
    copyright: '© Cloud Operator Days Tokyo 2022',
    privacy_policy: File.read(File.join(Rails.root, 'db/fixtures/production/privacy_policy.md')),
    coc: File.read(File.join(Rails.root, 'db/fixtures/production/coc.md')),
    committee_name: '',
    about: <<'EOS'
Cloud Operator Days Tokyo は、クラウドの運用者に焦点を当てた技術者向けの新しいテックイベントです。

クラウドの運用者とは、クラウド基盤（IaaS、PaaS、CaaS、FaaS）を運用しているインフラエンジニアの方だけではなく、クラウド基盤上でアプリケーションを作成し、運用している人も含みます。

オペレーションに関わる技術や悩み、解決策を 発表、共有していくことで運用技術の発展やインフラ、アプリケーション運用に興味がある若手の教育、育成ができるイベントとして発展させていきたいと考えております。

昨年の第2回は50以上のオンラインセッション、及びワンデーライブイベントを行い、延べ2000名以上の皆様にご参加いただきました。
https://cloudopsdays.com/archive/2021/

今年の開催はオンラインでのセッション配信、及びオンサイトでのクロージングイベントのハイブリッド開催を計画しております。（状況に応じて変更の可能性があります）

セッションは全て事前撮影した動画の放映といたします。１セッションあたりの時間は、20分を予定しています。
EOS
  }
)

ConferenceDay.seed(
  {id: 1, date: "2022-07-25", start_time: "13:00", end_time: "19:00", conference_id: 1, internal: false},
  {id: 2, date: "2022-05-31", start_time: "19:00", end_time: "21:00", conference_id: 1, internal: true} #Pre event
)
