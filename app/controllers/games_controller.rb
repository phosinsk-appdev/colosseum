class GamesController < ApplicationController
  
  before_action :set_genres

  def set_genres
    @genres = Game::GENRES
  end
  
  def index
    matching_games = Game.all

    @list_of_games = matching_games.order({ :title => :asc })

    render({ :template => "games/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_games = Game.where({ :id => the_id })

    @the_game = matching_games.at(0)

    render({ :template => "games/show.html.erb" })
  end

  def create
    
    the_game = Game.new
    the_game.title = params.fetch("query_title")
    the_game.release_date = params.fetch("query_release_date")
    the_game.description = params.fetch("query_description")
    the_game.image = params.fetch("query_image")
    the_game.publisher = params.fetch("query_publisher")
    the_game.genre = params.fetch("query_genre")

    if the_game.valid?
      the_game.save
      redirect_to("/games", { :notice => "Game created successfully." })
    else
      redirect_to("/games", { :alert => the_game.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_game = Game.where({ :id => the_id }).at(0)

    the_game.title = params.fetch("query_title")
    the_game.release_date = params.fetch("query_release_date")
    the_game.description = params.fetch("query_description")
    the_game.image = params.fetch("query_image")
    the_game.publisher = params.fetch("query_publisher")
    the_game.genre = params.fetch("query_genre")

    if the_game.valid?
      the_game.save
      redirect_to("/games/#{the_game.id}", { :notice => "Game updated successfully."} )
    else
      redirect_to("/games/#{the_game.id}", { :alert => the_game.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_game = Game.where({ :id => the_id }).at(0)

    the_game.destroy

    redirect_to("/games", { :notice => "Game deleted successfully."} )
  end
end
