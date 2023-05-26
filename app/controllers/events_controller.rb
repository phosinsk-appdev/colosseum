class EventsController < ApplicationController
  
  def home

     # pull first 5 rows and create instance variables for "teaser" tables on home page
      @funded_events = Event.where(:status => "funded").order({:date_target => :asc}).limit(5)

      @past_events = Event.where(:status => "complete").order({:date_target => :desc}).limit(5)

      @nearly_funded_events = Event.nearly_funded.order({:date_target => :asc}).limit(5)

    render({ :template => "events/home.html.erb" })

  end
  
  def index
    matching_games = Game.all

    @list_of_games = matching_games.order({ :title => :asc })
 
    filter = params[:filter]

    if filter == 'funded_upcoming'
      @list_of_events = Event.where(:status => "funded").order({:created_at => :desc})
      @table_header = "Upcoming Events"
    elsif filter == 'past'
      @list_of_events = Event.where(:status => "complete").order({:created_at => :desc})
      @table_header = "Past Events"
    elsif filter == 'so_close'
      @list_of_events = Event.nearly_funded.order({:created_at => :desc})
      @table_header = "So Close! Let's Make These Events Happen!"
    else
      @list_of_events = Event.where.not(:status => "complete").order({ :date_target => :asc})
      @table_header = "All Events"
    end

    render({ :template => "events/index.html.erb" })
  end

  def filter_by_game
    @list_of_games = Game.all.order({ :title => :asc })
    
    query_game_id = params[:query_game_id]
  
    if query_game_id.blank?
      @list_of_events = Event.all
    else
      game = Game.find(query_game_id)
      @list_of_events = game.events.where.not(:status => "complete")
      @table_header = "#{game.title} Events"
    end
  
    render({ :template => "events/index.html.erb" })
  end
  
  

  def show
    the_id = params.fetch("path_id")

    matching_events = Event.where({ :id => the_id })

    @the_event = matching_events.at(0)

    matching_games = Game.all

    @list_of_games = matching_games.order({ :title => :asc })

    @game = @the_event.game

    @creator = User.where(:id => @the_event.creator_id)

    @funds_raised = @the_event.donations.sum(:donation)

    if @current_user != nil
    @your_funds_raised = @the_event.donations.where(donator_id: @current_user.id).sum(:donation)
    end

    @teams = [1,2]

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
    the_event.watch_details = params.fetch("query_watch_details")
    the_event.battle_report = params.fetch("query_battle_report")
    the_event.winning_team = params.fetch("query_winning_team_id")

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
        redirect_to("/events/#{the_id}/set_funding_target", { :alert => "Funding target cannot exceed $100,000."} )
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
