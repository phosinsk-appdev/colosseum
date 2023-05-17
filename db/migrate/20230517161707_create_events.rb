class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.float :funding_target
      t.date :date_target
      t.date :date_deadline
      t.string :status
      t.integer :creator_id
      t.integer :game_id
      t.text :watch_details
      t.text :battle_report
      t.integer :winning_team

      t.timestamps
    end
  end
end
