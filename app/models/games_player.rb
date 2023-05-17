# == Schema Information
#
# Table name: games_players
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer
#  player_id  :integer
#
class GamesPlayer < ApplicationRecord

  belongs_to(:game, { :required => true, :class_name => "Game", :foreign_key => "game_id" })
  belongs_to(:player, { :required => true, :class_name => "Player", :foreign_key => "player_id" })

end
