class CreateLiveStream < ActiveRecord::Migration[6.0]
  def change
    create_table :live_streams do |t|
      t.belongs_to :conference, null: false, foreign_key: true, type: :bigint
      t.belongs_to :track, null: false, foreign_key: true, type: :bigint
      t.string :type
      t.json :params
    end
  end
end
