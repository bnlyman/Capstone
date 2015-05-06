class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :edit, :destroy, :enroll]
  before_action :set_user
  before_action :authenticate_user!, except: [:show]

  def new
    @event = @user.events.build

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @event = Event.new(event_params)
    @event.owner = events_owner
    @event.save
    
    respond_to do |format|
      format.html {redirect_to events_path}
      format.js
    end
  end

  def edit
    if current_user.admin?
      respond_to do |format|
        format.html
        format.js
      end   
    else
      flash[:danger] = "You cannot edit this event"
    end
  end

  def update
     if @event.update(event_params)
        flash.now[:success] = "You have edited an event"
        respond_to do |format|
        format.html {redirect_to events_path}
        format.js
      end
    else
      render :edit
    end
  end

  def destroy
    if @event.owner == current_user || current_user.admin?
      @event.destroy
      flash[:success] = "The Event was destroyed"
      redirect_to events_path
    else
      flash[:danger] = "You are not authorized to delete this event."
      redirect_to @event
    end
  end

  def show 
    @hash = Gmaps4rails.build_markers(@event) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
    @events = Event.all

    if !current_user.admin?
      redirect_to root_url
      flash[:danger] = "You are not authorized to view this page."
    end
  end

  def enroll
    if @event.total_spots == @event.users.count
      flash[:danger] = "Sorry, there aren't anymore spots available in the event: '#{@event.title}'."
      redirect_to root_url
    else
      @event.users << @user
      if @event.valid?
        redirect_to root_path
        flash[:success] = "You are enrolled in #{@event.title}"
      else
        @event.users.delete @user
        redirect_to root_path
        flash[:danger] = @event.errors.full_messages
      end
    end
  end

  private
  def event_params
    params.require(:event).permit(:title, :description, :datetime, :city, :state, :cost, :vacancies, :user_id, :total_spots, :address, :latitude, :longitude, :image )
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def events_owner
    @events_owner = current_user
  end
end