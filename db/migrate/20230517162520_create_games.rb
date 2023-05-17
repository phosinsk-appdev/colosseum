class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :title
      t.date :release_date
      t.text :description
      t.string :image
      t.string :publisher

      t.timestamps
    end
  end
end
