class EventsPlayersController < ApplicationController
  def index
    matching_events_players = EventsPlayer.all

    @list_of_events_players = matching_events_players.order({ :created_at => :desc })

    render({ :template => "events_players/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_events_players = EventsPlayer.where({ :id => the_id })

    @the_events_player = matching_events_players.at(0)

    render({ :template => "events_players/show.html.erb" })
  end

def add_player # DO THESE NEED TO BE SEPARATE? IS ONE REALLY FOR UPDATE?

  @event_id = params.fetch("path_id")
  @event = Event.where({ :id => @event_id }).at(0)
  @game_id = @event.game_id

  all_players = Player.all.order(nickname: :asc)
  this_game_players_ids = GamesPlayer.where({ :game_id => @game_id }).pluck(:player_id)
  
  @players_of_this_game = all_players.select { |player| this_game_players_ids.include?(player.id) }
  @other_players = all_players - @players_of_this_game

  @teams = [1,2]

  @event_players = EventsPlayer.where({ :event_id => @event_id })

  render({ :template => "events_players/add_player.html.erb" })

end

def validate_teams_and_proceed_to_funding
  @event = Event.find(params[:path_id])
  if @event.events_players.exists?(team: 1) && @event.events_players.exists?(team: 2)
    redirect_to("/events/#{@event.id}/set_funding_target")
  else
    redirect_to("/events_players/#{@event.id}/add_player", { :alert => "Each team must have at least one player." })

  end
end

def insert_player
  the_events_player = EventsPlayer.new
  the_events_player.event_id = params.fetch("path_id")
  the_events_player.team = params.fetch("query_team_id")
  the_events_player.player_id = params.fetch("query_player_id")

  if the_events_player.valid?
    the_events_player.save
    redirect_to("/events_players/#{the_events_player.event_id}/add_player", { :notice => "Player added successfully." })
  else
    redirect_to("/events_players/#{the_events_player.event_id}/add_player", { :alert => the_events_player.errors.full_messages.to_sentence })
end

def remove_player
  the_id = params.fetch("path_id")
  the_events_player = EventsPlayer.find_by(id: the_id)
  the_event_id = the_events_player.event_id
  the_events_player.destroy

  redirect_to("/events_players/#{the_event_id}/add_player", { :notice => "Player removed successfully." })
end

end

  def update
    the_id = params.fetch("path_id")
    the_events_player = EventsPlayer.where({ :id => the_id }).at(0)

    the_events_player.event_id = params.fetch("query_event_id")
    the_events_player.team = params.fetch("query_team")
    the_events_player.player_id = params.fetch("query_player_id")

    if the_events_player.valid?
      the_events_player.save
      redirect_to("/events_players/#{the_events_player.id}", { :notice => "Events player updated successfully."} )
    else
      redirect_to("/events_players/#{the_events_player.id}", { :alert => the_events_player.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_events_player = EventsPlayer.where({ :id => the_id }).at(0)

    the_events_player.destroy

    redirect_to("/events_players", { :notice => "Events player deleted successfully."} )
  end
end
