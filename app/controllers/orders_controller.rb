class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  def new
  	@order = Order.new
  end

  def index
    @user = User.find(params[:user_id])
  	@orders = @user.orders.order('event_id, created_at')
    @orders.each { |x|
      puts "Event #{x.event.name} Price #{x.price} Shares #{x.shares}"
    }
  end
  
  def show
    @order = Order.find(params[:id])
    puts @order
  end

  def create
  	@order = Order.new(order_params)
    @order.user_id = current_user.id
    @order.event_id = params[:event_id]
    @order.filled = fill_order(params[:event_id], @order.type, @order.price, @order.shares)

    @order.save

    redirect_to action: 'show', id: @order.id
  end

  private
  def order_params
    params.require(:order).permit(:price, :shares, :type)
  end

  def fill_order(event_id, type, price, shares)
    match_type = {"buy" => "sell", "sell" => "buy" }[type]
    price_comp = {"buy" => "<=",   "sell" => ">="  }[type]
    sort_order = {"buy" => "ASC",  "sell" => "DESC"}[type]
    @matching_orders = 
      Order.where(
        "event_id = ? AND type = ? AND price #{price_comp} ?", event_id, match_type, price
      ).order(
        "price #{sort_order}, created_at DESC")

    shares_filled = 0
    @matching_orders.each { |order| 
      puts "Price #{order.price} Shares #{order.shares} Filled #{order.filled}"
      puts "Shares to fill #{shares}, already filled #{shares_filled}"  
      if shares <= 0 then break end
      unfilled_shares = order.shares - order.filled
      if(shares >= unfilled_shares)
        shares -= unfilled_shares
        order.filled = order.shares # == order.filled += unfilled_shares
        shares_filled += unfilled_shares
      else #shares < unfilled_shares
        order.filled += shares
        shares_filled += shares
        shares -= unfilled_shares
      end
      puts "Saving Order.Filled #{order.filled}"
      order.save
    }
    puts "Returning shares_filled #{shares_filled}"
    shares_filled
    # find all opposite orders with bid > ask
    # count and fill number of shares
  end


end
