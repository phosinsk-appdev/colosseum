# == Schema Information
#
# Table name: games
#
#  id           :integer          not null, primary key
#  description  :text
#  genre        :string
#  image        :string
#  publisher    :string
#  release_date :date
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Game < ApplicationRecord

  # establish array of values for genre drop-down

  GENRES = ['Action', 'Adventure', 'Battle Royale', 'Fighting', 'First Person Shooter', 'MMORPG', 'MOBA', 'Puzzle', 'Racing', 'RPG', 'RTS', 'Simulation', 'Strategy', 'Sports', 'Third Person Shooter'].freeze
    
  # validations
  validates(:title, { :presence => { :message => "Please enter a title for this game." } })
  validates(:title, { :uniqueness => { :message => "A game by this title already exists." } })
  validates(:genre, { :presence => { :message => "Please enter the genre for this game." } })
  validates(:publisher, { :presence => { :message => "Please enter the publisher for this game." } })
  validates(:image, { :presence => { :message => "Please enter an image for this game." } })
  validates(:description, { :presence => { :message => "Please enter a description for this game." } })

  # association accessors
  has_many(:events, { :class_name => "Event", :foreign_key => "game_id", :dependent => :destroy })
  has_many(:games_players, { :class_name => "GamesPlayer", :foreign_key => "game_id", :dependent => :destroy })
  has_many(:players, { :class_name => "Player", :foreign_key => "main_game", :dependent => :destroy })
  has_many(:my_players, { :through => :games_players, :source => :player })

end
