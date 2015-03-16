class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :html
  helper :my_content
  
  helper_method :nl2br
  
  helper_method :universe_filter

  # Rails changed cookie format in rails 4, so log out all old users so they get the new version
  rescue_from JSON::ParserError, with: :force_user_logout
  def force_user_logout
    reset_session
    redirect_to login_path
  end
  
  # View Helpers
  def nl2br(string)
    #simple_format string
    string.gsub("\n\r","<br>").gsub("\r", "").gsub("\n", "<br />").html_safe
  end
  
  def universe_filter
  	universes = Universe.where(user_id: session[:user])
  	return if universes.length == 0
  	
  	unless @selected_universe_filter
  	  @selected_universe_filter = 'All universes'
  	end
  
  	html = '<span class="btn-group input-append help-inline">'
  	html << '<button class="btn dropdown-toggle" data-toggle="dropdown">'
  	html << '<i class="icon-globe"></i> ' + @selected_universe_filter + ' '
  	html << '<span class="caret"></span>'
  	html << '</button>'
  	html << '<ul class="dropdown-menu dropdown-picker">'
		html << '<li><a href="/plan/characters">All universes</a></li>'
  	universes.each do |i|
  		html << '<li><a href="/plan/characters/from/' + i.name.strip + '">' + i.name + '</a></li>'
  	end
  	html << '</ul>'
  	html << '</span>'

  	return html.html_safe
  end
  
  # Authentication
  def is_logged_in?
    session && session[:user]
  end
  
  def redirect_if_not_logged_in
    unless is_logged_in?
      redirect_to signup_path, :notice => "You must be logged in to do that!"
    end
  end

  def create_anonymous_account_if_not_logged_in
    unless is_logged_in?
      id = rand(10000000).to_s + rand(10000000).to_s # lol
      @user = User.new(:name => 'Anonymous-' + id.to_s, :email => id.to_s + '@localhost', :password => id.to_s)

      if @user.save
        session[:user] = @user.id
        session[:anon_user] = true
      else
        create_anonymous_account_if_not_logged_in
      end
    end
  end
  
  def require_ownership_of_character
  	character = Character.find(params[:id])
  	unless session[:user] and session[:user] == character.user.id
  	  redirect_to character_list_path, :notice => "You don't have permission to do that!"
  	end
  end
  
  def require_ownership_of_equipment
  	equipment = Equipment.find(params[:id])
  	unless session[:user] and session[:user] == equipment.user.id
  	  redirect_to equipment_list_path, :notice => "You don't have permission to do that!"
  	end
  end
  
  def require_ownership_of_language
  	language = Language.find(params[:id])
  	unless session[:user] and session[:user] == language.user.id
  	  redirect_to language_list_path, :notice => "You don't have permission to do that!"
  	end
  end
  
  def require_ownership_of_location
  	location = Location.find(params[:id])
  	unless session[:user] and session[:user] == location.user.id
  	  redirect_to location_list_path, :notice => "You don't have permission to do that!"
  	end
  end
  
  def require_ownership_of_magic
  	magic = Magic.find(params[:id])
  	unless session[:user] and session[:user] == magic.user.id
  	  redirect_to magic_list_path, :notice => "You don't have permission to do that!"
  	end
  end
  
  def require_ownership_of_universe
  	universe = Universe.find(params[:id])
  	unless session[:user] and session[:user] == universe.user.id
  	  redirect_to universe_list_path, :notice => "You don't have permission to do that!"
  	end
  end

  def hide_private_universe
    universe = Universe.find(params[:id])
    unless (session[:user] and session[:user] == universe.user.id) or universe.privacy.downcase == 'public'
      redirect_to universe_list_path, :notice => "You don't have permission to view that!"
    end
  end

  def hide_private_character
    character = Character.find(params[:id])
    unless (session[:user] and session[:user] == character.user.id) or (character.universe and character.universe.privacy.downcase == 'public')
      redirect_to character_list_path, :notice => "You don't have permission to view that!"
    end
  end

  def hide_private_equipment
    equipment = Equipment.find(params[:id])
    unless (session[:user] and session[:user] == equipment.user.id) or (equipment.universe and equipment.universe.privacy.downcase == 'public')
      redirect_to equipment_list_path, :notice => "You don't have permission to view that!"
    end
  end

  def hide_private_language
    language = Language.find(params[:id])
    unless (session[:user] and session[:user] == language.user.id) or (language.universe and language.universe.privacy.downcase == 'public')
      redirect_to language_list_path, :notice => "You don't have permission to view that!"
    end
  end

  def hide_private_location
    location = Location.find(params[:id])
    unless (session[:user] and session[:user] == location.user.id) or (location.universe and location.universe.privacy.downcase == 'public')
      redirect_to location_list_path, :notice => "You don't have permission to view that!"
    end
  end

  def hide_private_magic
    magic = Magic.find(params[:id])
    unless (session[:user] and session[:user] == magic.user.id) or (magic.universe and magic.universe.privacy.downcase == 'public')
      redirect_to magic_list_path, :notice => "You don't have permission to view that!"
    end
  end




end
