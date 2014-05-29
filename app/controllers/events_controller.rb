class EventsController < ApplicationController
  def new
  	@event = Event.new
  end

  def index
  	@events = Event.all

  	@bidask = @events.map {|event|
  		buyorders  = event.orders.select{|x| (x.type == "buy")  && (x.shares - x.filled > 0)}
  		sellorders = event.orders.select{|x| (x.type == "sell") && (x.shares - x.filled > 0)}
  		bid = nil
  		if buyorders.length > 0 
  		    bid = buyorders.sort{ |x, y| x.price <=> y.price }.last.price
  		end
  		ask = nil
  		if sellorders.length > 0
  			ask = sellorders.sort{ |x, y| x.price <=> y.price }.first.price
  		end
  		{event_id: event.id, bid: bid, ask: ask}
  	}
  end

  def show 
  	@event = Event.find(params[:id])
  	@orders = @event.orders.select{ |x| x.filled < x.shares }.sort{ |x, y| y.price <=> x.price }
  end

  private
  def get_bidask(event)

  end

end
