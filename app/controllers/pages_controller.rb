class PagesController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def buy
    @arts = Art.all
  end
end
