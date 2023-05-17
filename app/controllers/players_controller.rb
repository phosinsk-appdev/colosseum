class PlayersController < ApplicationController
  def index
    
    matching_games = Game.all

    @list_of_games = matching_games.order({ :title => :asc })
   
    matching_players = Player.all

    @list_of_players = matching_players.order({ :nickname => :asc })

    render({ :template => "players/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_players = Player.where({ :id => the_id })

    @the_player = matching_players.at(0)

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
