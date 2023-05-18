class EventsController < ApplicationController
  
  def home

    render({ :template => "events/home.html.erb" })

  end
  
  def index
    matching_games = Game.all

    @list_of_games = matching_games.order({ :title => :asc })
   
    matching_events = Event.all

    @list_of_events = matching_events.order({ :created_at => :desc })

    render({ :template => "events/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_events = Event.where({ :id => the_id })

    @the_event = matching_events.at(0)

    render({ :template => "events/show.html.erb" })
  end

  def create
    the_event = Event.new
    the_event.title = params.fetch("query_title")
    the_event.description = params.fetch("query_description")
    # the_event.funding_target = params.fetch("query_funding_target")
    the_event.date_target = params.fetch("query_date_target")
    the_event.date_deadline = params.fetch("query_date_deadline")
    the_event.status = params.fetch("query_status")
    the_event.creator_id = @current_user.id
    the_event.game_id = params.fetch("query_game_id")
    # the_event.watch_details = params.fetch("query_watch_details")
    # the_event.battle_report = params.fetch("query_battle_report")
    # the_event.winning_team = params.fetch("query_winning_team")

    if the_event.valid?
      the_event.save
      redirect_to("/events_players/#{the_event.id}/add_player", { :notice => "Event created successfully." })
    else
      redirect_to("/events", { :alert => the_event.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_event = Event.where({ :id => the_id }).at(0)

    the_event.title = params.fetch("query_title")
    the_event.description = params.fetch("query_description")
    the_event.funding_target = params.fetch("query_funding_target")
    the_event.date_target = params.fetch("query_date_target")
    the_event.date_deadline = params.fetch("query_date_deadline")
    # the_event.status = params.fetch("query_status")
    the_event.creator_id = params.fetch("query_creator_id")
    the_event.game_id = params.fetch("query_game_id")
    # the_event.watch_details = params.fetch("query_watch_details")
    # the_event.battle_report = params.fetch("query_battle_report")
    # the_event.winning_team = params.fetch("query_winning_team")

    if the_event.valid?
      the_event.save
      redirect_to("/events/#{the_event.id}", { :notice => "Event updated successfully."} )
    else
      redirect_to("/events/#{the_event.id}", { :alert => the_event.errors.full_messages.to_sentence })
    end
  end

  def set_funding_target
    the_id = params.fetch("path_id")
    @event = Event.where({ :id => the_id }).at(0)
    @min_funding_target = @event.players.maximum(:event_minimum)
  end

  def update_funding_target
    the_id = params.fetch("path_id")
    @event = Event.where({ :id => the_id }).at(0)
    @min_funding_target = @event.players.maximum(:event_minimum)

    @event.funding_target = params[:query_funding_target]

    if @event.funding_target >= @min_funding_target
      if @event.funding_target <= 100000
        @event.save
        redirect_to("/events/#{the_id}", { :notice => "Funding target was successfully updated."} )
      else
        redirect_to("/events/#{the_id}/set_funding_target", { :alert => "Funding target cannot exceed $100,000"} )
      end
    else
      redirect_to("/events/#{the_id}/set_funding_target", { :notice => "Funding target not updated - below minimum given players involved (#{@min_funding_target})"} )
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_event = Event.where({ :id => the_id }).at(0)

    the_event.destroy

    redirect_to("/events", { :notice => "Event deleted successfully."} )
  end
end
