class OrdersController < ApplicationController
  # Lists all artworks available for purchase.
  # The user doesn't have to be signed in to purhcase art and can preview all artworks.
  # All art is eager loaded using the .includes method to use fewer queries to optimize site performance.
  def buy
    @arts = Art.includes(params[:art]).limit(10)
  end

  # New action queries the Art model to find the params of the selected art.
  # View enables a user to purchase a selected artwork.
  # In the view the user can click "Checkout Now" which then redirects them to the payment portal (third party payment API Stripe.com)
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
