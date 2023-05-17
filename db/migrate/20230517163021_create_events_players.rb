class CreateEventsPlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :events_players do |t|
      t.integer :event_id
      t.integer :team
      t.integer :player_id

      t.timestamps
    end
  end
end
