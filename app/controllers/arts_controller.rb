class ArtsController < ApplicationController
  before_action :authenticate_user!, only: :new
  before_action :set_art, only: [:show, :edit, :update, :destroy]

  # GET /arts
  # GET /arts.json
  # Renders arts/index.html.erb view which takes the current signed-in user to their account page "My Account". 
  #This action view shows all the artworks saved to the signed-in user's account.
  def index 
    @arts = Art.where(user_id: current_user.id)
  end

  # GET /arts/1
  # GET /arts/1.json
  # Renders art/show.html.erb view which will enable user to edit or remove artwork only if they are the owner, else "Buy Now" option if not art owner.
  def show
    @art = Art.find(params[:id])
  end

  # GET /arts/new
  # New action permits a signed in user to add art to their account which will then be listed to their account through the arts index action and visible to buyers on the "Buy Art" page
  def new
    @art = Art.new
  end

  # GET /arts/1/edit
  # This action allows only the authorised owner of a listed artwork to edit their artwork
  def edit
    unless current_user == @art.user
      redirect_back fallback_location: root_path, notice: 'Please sign in'
    end
  end

  # POST /arts
  # POST /arts.json
  # A signed-in user can add art to their account. 
  # When user saves a new artwork they will be given ownership of their art, user id will be linked to the artwork id.
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
  # Update action allows the current signed-in user to updated their art
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
  # Destroy action allows only the authorised owner of a listed artwork to destroy/remove their artwork
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
    # The if authorize action redirects the user to the home page if they are not the owner of an artwork.
    # The else will render the signed-in user's art
    # 
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
      params.require(:art).permit(:picture, :title, :description, :size, :price, :user_id, :username)
    end
end
