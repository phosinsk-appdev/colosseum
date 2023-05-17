Rails.application.routes.draw do



  # Routes for the Games player resource:

  # CREATE
  post("/insert_games_player", { :controller => "games_players", :action => "create" })
          
  # READ
  get("/games_players", { :controller => "games_players", :action => "index" })
  
  get("/games_players/:path_id", { :controller => "games_players", :action => "show" })
  
  # UPDATE
  
  post("/modify_games_player/:path_id", { :controller => "games_players", :action => "update" })
  
  # DELETE
  get("/delete_games_player/:path_id", { :controller => "games_players", :action => "destroy" })

  #------------------------------

  # Routes for the Events player resource:

  # CREATE
  post("/insert_events_player", { :controller => "events_players", :action => "create" })
          
  # READ
  get("/events_players", { :controller => "events_players", :action => "index" })
  
  get("/events_players/:path_id", { :controller => "events_players", :action => "show" })
  
  # UPDATE
  
  post("/modify_events_player/:path_id", { :controller => "events_players", :action => "update" })
  
  # DELETE
  get("/delete_events_player/:path_id", { :controller => "events_players", :action => "destroy" })

  #------------------------------

  # Routes for the Player resource:

  # CREATE
  post("/insert_player", { :controller => "players", :action => "create" })
          
  # READ
  get("/players", { :controller => "players", :action => "index" })
  
  get("/players/:path_id", { :controller => "players", :action => "show" })
  
  # UPDATE
  
  post("/modify_player/:path_id", { :controller => "players", :action => "update" })
  
  # DELETE
  get("/delete_player/:path_id", { :controller => "players", :action => "destroy" })

  #------------------------------

  # Routes for the Game resource:

  # CREATE
  post("/insert_game", { :controller => "games", :action => "create" })
          
  # READ
  get("/games", { :controller => "games", :action => "index" })
  
  get("/games/:path_id", { :controller => "games", :action => "show" })
  
  # UPDATE
  
  post("/modify_game/:path_id", { :controller => "games", :action => "update" })
  
  # DELETE
  get("/delete_game/:path_id", { :controller => "games", :action => "destroy" })

  #------------------------------

  # Routes for the User account:

  # SIGN UP FORM
  get("/user_sign_up", { :controller => "user_authentication", :action => "sign_up_form" })        
  # CREATE RECORD
  post("/insert_user", { :controller => "user_authentication", :action => "create"  })
      
  # EDIT PROFILE FORM        
  get("/edit_user_profile", { :controller => "user_authentication", :action => "edit_profile_form" })       
  # UPDATE RECORD
  post("/modify_user", { :controller => "user_authentication", :action => "update" })
  
  # DELETE RECORD
  get("/cancel_user_account", { :controller => "user_authentication", :action => "destroy" })

  # ------------------------------

  # SIGN IN FORM
  get("/user_sign_in", { :controller => "user_authentication", :action => "sign_in_form" })
  # AUTHENTICATE AND STORE COOKIE
  post("/user_verify_credentials", { :controller => "user_authentication", :action => "create_cookie" })
  
  # SIGN OUT        
  get("/user_sign_out", { :controller => "user_authentication", :action => "destroy_cookies" })
             
  #------------------------------

  # Routes for the Event resource:

  # CREATE
  post("/insert_event", { :controller => "events", :action => "create" })
          
  # READ
  get("/events", { :controller => "events", :action => "index" })
  
  get("/events/:path_id", { :controller => "events", :action => "show" })
  
  # UPDATE
  
  post("/modify_event/:path_id", { :controller => "events", :action => "update" })
  
  # DELETE
  get("/delete_event/:path_id", { :controller => "events", :action => "destroy" })

  #------------------------------

end
