class ChargesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_event
	before_action :verify_user

	def new
		if @event.total_spots == @event.users.count
      flash[:danger] = "Sorry, there aren't anymore spots available in the event: '#{@event.title}'."
      redirect_to root_url
    end
	end

	def create
		if @event.total_spots == @event.users.count
      flash[:danger] = "Sorry, there aren't anymore spots available in the event: '#{@event.title}'."
      redirect_to root_url
    end
	  # Amount in cents
	  @amount = @event.cost * 100

	  customer = Stripe::Customer.create(
	    :email => 'example@stripe.com',
	    :card  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => @amount,
	    :description => 'Rails Stripe customer',
	    :currency    => 'usd'
	  )

	  @charge = Transaction.new(stripe_id: charge['id'], user_id: current_user.id, amount: charge['amount'], paid: charge['paid'], event_id: @event.id, event_name: @event.title)
	  @charge.save

	  redirect_to enroll_path(@event)

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to charges_path
	end

	private
	def set_event
		@event = Event.find(params[:event_id])
	end

	def verify_user
		if current_user == @event.owner || @event.users.include?(current_user)
	  	flash[:danger] = "You cannot enroll in this event."
	  	redirect_to root_url
	  end
	end
end
