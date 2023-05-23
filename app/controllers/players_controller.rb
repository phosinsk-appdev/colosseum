class PlayersController < ApplicationController
  
  before_action :ensure_admin!, only: [:create, :update, :destroy]
  
  def index
    
    matching_games = Game.all

    @list_of_games = matching_games.order({ :title => :asc })
   
    game_id = params.fetch("query_game_id", nil)
  
    if game_id.blank?
      matching_players = Player.all
    else
      # Fetch players who have the game in their games
      matching_players = Player.where({:main_game => game_id})
    end

    @list_of_players = matching_players.order({ :nickname => :asc })

    render({ :template => "players/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_players = Player.where({ :id => the_id })

    @the_player = matching_players.at(0)

    matching_games = Game.all

    @list_of_games = matching_games.order({ :title => :asc })

    #calculate wins, losses, and earnings

    @event_history = @the_player.event_history
    @the_player_wins = @the_player.calculate_total_wins
    @the_player_earnings = @the_player.calculate_total_earnings
    @the_player_losses = @event_history.count - @the_player_wins

    render({ :template => "players/show.html.erb" })
  end

  def create
    the_player = Player.new
    the_player.nickname = params.fetch("query_nickname")
    the_player.dob = params.fetch("query_dob")
    the_player.bio = params.fetch("query_bio")
    the_player.event_minimum = params.fetch("query_event_minimum")
    the_player.email = params.fetch("query_email")
    the_player.phone_number = params.fetch("query_phone_number")
    the_player.social_one = params.fetch("query_twitch")
    the_player.social_two = params.fetch("query_youtube")
    the_player.social_three = params.fetch("query_twitter")
    the_player.social_four = params.fetch("query_liquipedia")
    the_player.main_game = params.fetch("query_main_game")

    if the_player.valid?
      the_player.save

      # add main game association to games_players table for simple look up
      GamesPlayer.find_or_create_by(player_id: the_player.id, game_id: the_player.main_game)


      # Associate additional games with player in games_players table
      additional_games = params.fetch("query_additional_games", []).map(&:to_i)
   
      # Remove the main game from additional games if it's there
      additional_games = additional_games - [the_player.main_game]

      additional_games.each do |game_id|
      GamesPlayer.create(player_id: the_player.id, game_id: game_id)
      end

      redirect_to("/players", { :notice => "Player created successfully." })
    else
      redirect_to("/players", { :alert => the_player.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_player = Player.where({ :id => the_id }).at(0)

    the_player.nickname = params.fetch("query_nickname")
    the_player.dob = params.fetch("query_dob")
    the_player.bio = params.fetch("query_bio")
    the_player.event_minimum = params.fetch("query_event_minimum")
    the_player.email = params.fetch("query_email")
    the_player.phone_number = params.fetch("query_phone_number")
    the_player.social_one = params.fetch("query_twitch")
    the_player.social_two = params.fetch("query_youtube")
    the_player.social_three = params.fetch("query_twitter")
    the_player.social_four = params.fetch("query_liquipedia")
    the_player.main_game = params.fetch("query_main_game")

    if the_player.valid?
      the_player.save
      redirect_to("/players/#{the_player.id}", { :notice => "Player updated successfully."} )
    else
      redirect_to("/players/#{the_player.id}", { :alert => the_player.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_player = Player.where({ :id => the_id }).at(0)

    the_player.destroy

    redirect_to("/players", { :notice => "Player deleted successfully."} )
  end
end
