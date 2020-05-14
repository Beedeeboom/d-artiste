class ArtsController < ApplicationController
  before_action :authenticate_user!, only: :new
  before_action :set_art, only: [:show, :edit, :update, :destroy]

  # GET /arts
  # GET /arts.json
  def index
    @arts = Art.where(user_id: current_user.id)
  end

  # GET /arts/1
  # GET /arts/1.json
  def show
    @art = Art.find(params[:id])
  end

  # GET /arts/new
  def new
    @art = Art.new
  end

  # GET /arts/1/edit
  def edit
    unless current_user == @art.user
      redirect_back fallback_location: root_path, notice: 'Please sign in'
    end
  end

  # POST /arts
  # POST /arts.json
  def create
    @art = Art.new(art_params)
    @art.user_id = current_user.id
    @art.picture.attach(art_params[:picture])
    respond_to do |format|
      if @art.save
        format.html { redirect_to @art, notice: 'Art was successfully created.' }
        format.json { render :show, status: :created, location: @art }
      else
        format.html { render :new }
        format.json { render json: @art.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /arts/1
  # PATCH/PUT /arts/1.json
  def update
    respond_to do |format|
      if @art.update(art_params)
        format.html { redirect_to @art, notice: 'Art was successfully updated.' }
        format.json { render :show, status: :ok, location: @art }
      else
        format.html { render :edit }
        format.json { render json: @art.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /arts/1
  # DELETE /arts/1.json
  def destroy
    unless current_user == @art.user
      redirect_back fallback_location: root_path, notice: 'Please sign in'
    else
        @art.destroy
        respond_to do |format|
          format.html { redirect_to arts_url, notice: 'Art was successfully destroyed.' }
          format.json { head :no_content }
      end
    end
  end

  private

    def authorize
      if !current_user.has_role?(:artist)
        flash[:alert]= "You are not authorized!"
        redirect_to root_path
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_art
      @art = Art.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def art_params
      params.require(:art).permit(:picture, :title, :description, :size, :price, :user_id)
    end
end
