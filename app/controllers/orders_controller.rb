class OrdersController < ApplicationController
  # Buy order action render the "Buy Art" view which list all artworks available for purchase.
  # The user doesn't have to be signed in to purhcase art and can preview all artworks.
  def buy
    @arts = Art.all
  end

  # New order action enables a user to purchase a selected artwork.
  # Redirects the user to the first view which lists the artwork they wish to purchase.
  # User can click "Checkout Now" which then redirects them to the payment portal.
  # Third party payment API (Stripe.com)
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
