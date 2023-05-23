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
  has_many(:games, { :through => :games_players, :source => :game })

  # define event history method
  def event_history
    self.events.where(status: 'complete').order(created_at: :desc)
  end

  # finding what team a player was on in an event
  def team_in_event(event)
    events_player = self.events_players.find_by(event_id: event.id)
    if events_player
      return events_player.team
    else
      return nil
    end
  end

  # calculating total wins and earnings

  def calculate_total_wins
    total_wins = 0
    if self.events_players.exists?
      self.events_players.each do |events_player|
        event = events_player.event
        if event.status == "complete" && event.winning_team == team_in_event(event)
          total_wins += 1
        end
      end
    end
    return total_wins
  end
  
  
  def calculate_total_earnings
    total_earnings = 0
    self.events_players.each do |events_player|
      event = events_player.event
      if event.status == "complete" && event.winning_team == team_in_event(event)
        winning_team = team_in_event(event)
        count_of_winning_team_members = event.events_players.where(team: winning_team).count
        earnings_for_this_event = event.funding_target / count_of_winning_team_members
        total_earnings += earnings_for_this_event
      end
    end
    return total_earnings
  end
  
        def event_history_table
          events = event_history # You already have the method event_history
          table = []
        
          events.each do |event|
            # Get event player record for this event
            events_player = self.events_players.find_by(event_id: event.id)
            if events_player
              team_number = events_player.team
        
              # Check if the player's team won or lost
              win_or_loss = event.winning_team == team_number ? "Win" : "Loss"
        
              # Calculate earnings
              earnings = win_or_loss == "Win" ? event.funding_target / event.events_players.where(team: event.winning_team).count : 0
        
              # Get winning and losing teams
              winning_team_ids = event.events_players.where(team: event.winning_team).map(&:player_id)
              losing_team_ids = event.events_players.where.not(team: event.winning_team).map(&:player_id)
        
              # Get player nicknames for winning and losing teams
              winning_team_nicknames = Player.where(id: winning_team_ids).map(&:nickname).join(', ')
              losing_team_nicknames = Player.where(id: losing_team_ids).map(&:nickname).join(', ')
        
              # Build a row
              row = {
                "Win/Loss" => win_or_loss,
                "Title" => event.title,
                "Game" => event.game.title,
                "Funding Goal" => event.funding_target,
                "Description" => event.description,
                "Winning Team" => "#{event.winning_team} (#{winning_team_nicknames})",
                "Losing Team" => "#{team_number == event.winning_team ? team_number + 1 : team_number - 1} (#{losing_team_nicknames})",
                "Earnings" => earnings
              }
        
              # Add the row to the table
              table << row
            end
          end
        
          return table
        end
  

end
