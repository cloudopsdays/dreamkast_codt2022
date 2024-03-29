class CreateSponsors< ActiveRecord::Migration[6.0]
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :abbr
      t.text :description
      t.string :url
      t.belongs_to :conference, null: false, foreign_key: true, type: :bigint

      t.timestamps
    end

    create_table :sponsor_attachments do |t|
      t.belongs_to :sponsor, null: false, foreign_key: true, type: :bigint
      t.string :type
      t.string :title
      t.string :url
      t.text :text
      t.string :link
      t.boolean :public
      t.string :file_data

      t.timestamps
    end
  end
end
