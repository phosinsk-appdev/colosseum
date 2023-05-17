class AddMainToPlayers < ActiveRecord::Migration[6.0]
  def change

    add_column :players, :main_game, :integer

  end
end
