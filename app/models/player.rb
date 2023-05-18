# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  bio           :text
#  dob           :date
#  email         :string
#  event_minimum :float
#  main_game     :integer
#  nickname      :string
#  phone_number  :string
#  social_four   :string
#  social_one    :string
#  social_three  :string
#  social_two    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Player < ApplicationRecord

  # validations
  validates(:nickname, { :presence => { :message => "Please enter the player's nickname." } })
  validates(:event_minimum, { :presence => { :message => "Please provide the player's event minimum. " } })
  validates(:email, { :presence => { :message => "Please enter the player's email address. " } })
  validates(:dob, { :presence => { :message => "Please enter the player's DOB." } })
  validates(:bio, { :presence => { :message => "Please provide a brief bio for the player." } })

  # association accessors
  has_many(:games_players, { :class_name => "GamesPlayer", :foreign_key => "player_id", :dependent => :destroy })
  has_many(:events_players, { :class_name => "EventsPlayer", :foreign_key => "player_id" })
  belongs_to(:main, { :required => true, :class_name => "Game", :foreign_key => "main_game" })

  has_many(:events, { :through => :events_players, :source => :event })

end
