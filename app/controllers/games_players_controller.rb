class GamesPlayersController < ApplicationController
  def index
    matching_games_players = GamesPlayer.all

    @list_of_games_players = matching_games_players.order({ :created_at => :desc })

    render({ :template => "games_players/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_games_players = GamesPlayer.where({ :id => the_id })

    @the_games_player = matching_games_players.at(0)

    render({ :template => "games_players/show.html.erb" })
  end

  def create
    the_games_player = GamesPlayer.new
    the_games_player.player_id = params.fetch("query_player_id")
    the_games_player.game_id = params.fetch("query_game_id")

    if the_games_player.valid?
      the_games_player.save
      redirect_to("/games_players", { :notice => "Games player created successfully." })
    else
      redirect_to("/games_players", { :alert => the_games_player.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_games_player = GamesPlayer.where({ :id => the_id }).at(0)

    the_games_player.player_id = params.fetch("query_player_id")
    the_games_player.game_id = params.fetch("query_game_id")

    if the_games_player.valid?
      the_games_player.save
      redirect_to("/games_players/#{the_games_player.id}", { :notice => "Games player updated successfully."} )
    else
      redirect_to("/games_players/#{the_games_player.id}", { :alert => the_games_player.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_games_player = GamesPlayer.where({ :id => the_id }).at(0)

    the_games_player.destroy

    redirect_to("/games_players", { :notice => "Games player deleted successfully."} )
  end
end
