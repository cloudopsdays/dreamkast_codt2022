require 'slack/incoming/webhooks'

namespace :util do
  desc 'add_talks_for_codt2022_closing'
  task add_talks_for_codt2022_closing: :environment do
    ActiveRecord::Base.logger = Logger.new($stdout)
    Rails.logger.level = Logger::DEBUG

    conference = Conference.find_by(abbr: 'codt2022')
    conference_day = conference.conference_days.where(date: '2022-07-27').first
    track_a = conference.tracks.find_by(name: '大規模システム運用')

    talks = [
      { start_time: '09:00:00', end_time: '09:30:00', title: 'dummy', abstract: 'intermission' },
      { start_time: '09:30:00', end_time: '10:00:00', title: '開始までお待ちください', abstract: 'intermission' },
      { start_time: '10:00:00', end_time: '10:10:00', title: 'オープニング',
       abstract: '長谷川 章博 （CODT2022 実行委会 委員長/AXLBIT株式会社）' },
      { start_time: '10:10:00', end_time: '10:50:00', title: 'キーノートセッション① ', abstract: <<~ABSTRACT },
        デジタル田園都市構想を実現するクラウドインフラ
        デジタル田園都市国家構想は、Society5.0実現に向けた国家戦略であり、コロナ禍は、さらに、SDGsとカーボンニュートラルの実現を人類の必須条件とした。DXとCNの実現を単一組織で実現するだけでは不可能であり、サプライチェーンでのシステムの設計・実装・運用が、ローカル・国内・グローバルで実現されることが必須となる。さらに、情報通信システム自身の革新的な進化が、デバイス・実装構造・運用のすべての領域において必要となる。

        江崎 浩 氏 (デジタル庁 Chief Architect/東京大学 教授)
      ABSTRACT
      { start_time: '10:50:00', end_time: '11:20:00', title: 'キーノートセッション②', abstract: <<~ABSTRACT },
        Combining Forces: How Open Source Cloud Collaboration is Tackling a Trillion Dollar Industry
        Experts project that the technology industry is on pace to exceed $5.3 trillion in 2022 (source: IDC). The OpenInfra Foundation will discuss where the cloud market sits within this multi-trillion dollar industry, and how the OpenInfra Foundation is assembling open source communities backed by a growing group of organizations. Together, they are building new open source communities to address emerging open infrastructure demands including confidential computing, digital sovereignty, DPUs, ESI, and security. Hear what challenges these cloud operators are facing and how open source enables collaboration without boundaries.
        Mark Collier (COO, OpenInfra Foundation)
      ABSTRACT
      { start_time: '11:20:00', end_time: '12:00:00', title: 'キーノートセッション③', abstract: <<~ABSTRACT },
        ドコモMECの実現とクラウドのリアル
        NTTドコモでは5G時代の新しいサービスとして、docomo Open Innovation Cloud（現ドコモMEC）を2020年6月から提供を開始しました。また、国内初となる大都市圏以外でのMEC提供も今年の４月から開始しております。ドコモに限らず、他のキャリアも続々とMECサービスを開始しているなかで、そもそも5GのMECとは何なのか、パブリッククラウドと何が違うのか、ドコモのMECはどのように提供されているのか、また今後どうしようとしているのかについてご紹介します。
        秋永 和計 (株式会社NTTドコモ クロステック開発部 担当部長)
      ABSTRACT
      { start_time: '13:10:00', end_time: '14:20:00', title: 'よそはどうなの？　Cloud CoEパネルディスカッション', abstract: <<~ABSTRACT },
        Cloud Center of Excellence(CCoE)とよばれる全社横断型のクラウド推進組織を立ち上げる企業が増えています。なかなか進まないクラウド活用を推進、既にクラウド活用が進んでいるので統制、クラウドに関わるトラブル対応の集約等々、各社のミッションは異なります。本パネルディスカッションでは、昨年、日本初の「CCoE本」を上梓したグーグルクラウドジャパン合同会社 黒須義一さんと、共著の酒井真弓さんがモデレータ、東日本電信電話株式会社、株式会社日立ソリューションズ、株式会社デンソーでCCoEをリードしているエンジニアがパネリストとして登壇し、CCoEの役割と苦労話について語っていただきます。なかなか聞けない組織論をテーマとしており、クラウド活用・運用に課題を感じている方必聴です。

        参考：CCoE関連のオンデマンドセッション詳細

        CCoE特別講座　～エンジニアに贈るクラウド推進組織活用法～
        https://event.cloudopsdays.com/codt2022/talks/12

        通信だけの会社じゃない！NTT東日本が取り組むCCoE活動
        https://event.cloudopsdays.com/codt2022/talks/25

        たった3名でCloud CoEを立ち上げてみた
        https://event.cloudopsdays.com/codt2022/talks/39

        モデレーター:
        酒井 真弓（ノンフィクションライター）
        黒須 義一（グーグルクラウドジャパン合同会社）

        パネリスト：
        栗原 浩（株式会社デンソー）
        五味 健太（東日本電信電話株式会社）
        三好 秀徳（株式会社日立ソリューションズ）'
      ABSTRACT
      { start_time: '14:30:00', end_time: '15:10:00', title: '「輝け！クラウドオペレーターアワード2022」授賞式', abstract: <<~ABSTRACT },
        審査委員：
        関谷 勇司 (東京大学 教授)
        新野 淳一（ITジャーナリスト/Publickeyブロガー）
        松下 康之 (フリーランスライター)
        高橋 正和 (フリーランスライター)'
      ABSTRACT
      { start_time: '15:20:00', end_time: '16:00:00', title: '特別講演　「CSDX: クレディセゾンのDXへの取り組み」', abstract: <<~ABSTRACT },
        クレディセゾンでは2019年からデジタル人材の採用と育成を加速させ、2021年にはCSDX Visionを策定し、2024年にはデジタル人材を全社員の20%超の1000人に、2025年にはシステムの80%をクラウドに移行することを目指しています。従来の安定性重視のスタンス（モード1）と、スタートアップ的なスピード重視のスタンス（モード2）を互いに否定することなく融和させ、企画、開発、運用に取り組んでいるのかをご紹介します。
        小野 和俊 (株式会社クレディセゾン 取締役（兼）専務執行役員　CTO（兼）CIO)'
      ABSTRACT
      { start_time: '16:10:00', end_time: '17:10:00', title: 'パネルディスカッション「テレコム運用のクラウドネイティブ化における持続性の課題」', abstract: <<~ABSTRACT },
        5G時代にむけ、通信事業者でもNFV基盤などにおけるクラウドネイティブ化が進められています。一方で高いSLAなど、キャリアならではの課題もあります。本セッションでは、昨年に引き続き、主要モバイルキャリアのメンバーに登壇いただき、テレコム運用におけるクラウドネイティブ化の課題や、運用の工夫、導入前後の運用の変化など、生の声を聞かせていただきます。本セッションはCloud Native Telecom Operators Meetup(CNTOM)とのコラボセッションとなります。

        モデレーター：
        関谷 勇司 (東京大学 教授)

        パネリスト：
        清水 和人（株式会社NTTドコモ）
        Ashiq Khan（ソフトバンク株式会社）
        小杉正昭（楽天モバイル株式会社）
      ABSTRACT
      { start_time: '17:10:00', end_time: '17:20:00', title: 'クロージング',
        abstract: '水野 伸太郎 （日本OpenStackユーザ会 会長/日本電信電話株式会社）' },
      { start_time: '17:20:00', end_time: '20:00:00', title: 'Cloud Operator Days Tokyo 2022 クロージングイベントは終了しました', abstract: 'intermission' }
    ]

    talks.each do |param|
      add_intermission(conference, conference_day, track_a, param)
    end
  end

  def add_intermission(conference, conference_day, track, param)
    talk = Talk.new(param.merge(conference_id: conference.id, conference_day_id: conference_day.id, track_id: track.id, show_on_timetable: false))
    talk.save!
    if talk.abstract != 'intermission'
      proposal = Proposal.new(conference_id: conference.id, talk_id: talk.id, status: 1)
      proposal.save!
    end
    video = Video.new(talk_id: talk.id, on_air: false)
    video.save!
  end
end
