# == Schema Information
#
# Table name: games
#
#  id           :integer          not null, primary key
#  description  :text
#  image        :string
#  publisher    :string
#  release_date :date
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Game < ApplicationRecord

  # validations
  validates(:title, { :presence => { :message => "Please enter a title for this game." } })
  validates(:title, { :uniqueness => { :message => "A game by this title already exists." } })
  validates(:publisher, { :presence => { :message => "Please enter the publisher for this game." } })
  validates(:image, { :presence => { :message => "Please enter an image for this game." } })
  validates(:description, { :presence => { :message => "Please enter a description for this game." } })

  # association accessors
  has_many(:events, { :class_name => "Event", :foreign_key => "game_id", :dependent => :destroy })
  has_many(:games_players, { :class_name => "GamesPlayer", :foreign_key => "game_id", :dependent => :destroy })

end
