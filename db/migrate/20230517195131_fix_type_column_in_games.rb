class FixTypeColumnInGames < ActiveRecord::Migration[6.0]
  def change

    remove_column :games, :type

    add_column :games, :genre, :string

  end
end
