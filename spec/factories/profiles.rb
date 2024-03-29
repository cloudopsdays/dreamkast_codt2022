# == Schema Information
#
# Table name: profiles
#
#  id                            :integer          not null, primary key
#  sub                           :string(255)
#  email                         :string(255)
#  last_name                     :string(255)
#  first_name                    :string(255)
#  industry_id                   :integer
#  occupation                    :string(255)
#  company_name                  :string(255)
#  company_email                 :string(255)
#  company_address               :string(255)
#  company_tel                   :string(255)
#  department                    :string(255)
#  position                      :string(255)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  conference_id                 :integer
#  company_address_prefecture_id :string(255)
#  first_name_kana               :string(255)
#  last_name_kana                :string(255)
#  physically_attend             :boolean          default("0")
#

FactoryBot.define do
  factory :alice, class: Profile do
    id { 1 }
    sub { 'alice' }
    email { 'alice@example.com' }
    last_name { 'alice' }
    first_name { 'Alice' }
    industry_id { '1' }
    occupation { 'aaa' }
    company_name { 'aa' }
    company_email { 'alice_company@example.com' }
    company_address { 'aa' }
    company_tel { '123-4567-8901' }
    department { 'aa' }
    position { 'aaa' }
    conference_id { 1 }

    trait :on_codt2022 do
      id { 1 }
      conference_id { 1 }
    end

    trait :on_o11y2022 do
      id { 2 }
      conference_id { 2 }
    end
  end

  factory :bob, class: Profile do
    id { 3 }
    sub { 'bob' }
    email { 'bob@example.com' }
    last_name { 'bob' }
    first_name { 'Bob' }
    industry_id { '1' }
    occupation { 'aaa' }
    company_name { 'aa' }
    company_email { 'bob_company@example.com' }
    company_address { 'aa' }
    company_tel { '123-4567-8901' }
    department { 'aa' }
    position { 'aaa' }
    conference_id { 1 }

    trait :on_codt2022 do
      conference_id { 1 }
    end

    trait :on_o11y2022 do
      conference_id { 2 }
    end
  end
end
