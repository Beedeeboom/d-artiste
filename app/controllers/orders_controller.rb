class OrdersController < ApplicationController

  def buy
    @arts = Art.all
  end

  def new
    @art = Art.find(params[:art_id])
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: @art.title,
        description: @art.description,
        amount: (@art.price * 100).to_i,
        currency: 'aud',
        quantity: 1,
      }],
      success_url: 'http://localhost:3000/orders/complete',
      cancel_url: 'http://localhost:3000',
    )
    puts @session
  end

  def complete
  end
end
