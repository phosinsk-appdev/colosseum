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

  def create
    the_events_player = EventsPlayer.new
    the_events_player.event_id = params.fetch("query_event_id")
    the_events_player.team = params.fetch("query_team")
    the_events_player.player_id = params.fetch("query_player_id")

    if the_events_player.valid?
      the_events_player.save
      redirect_to("/events_players", { :notice => "Events player created successfully." })
    else
      redirect_to("/events_players", { :alert => the_events_player.errors.full_messages.to_sentence })
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
