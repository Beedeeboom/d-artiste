class OrdersController < ApplicationController

  def buy
    @arts = Art.all
  end
  
  def new
    @art = Art.find(params[:art_id])
  end
end
