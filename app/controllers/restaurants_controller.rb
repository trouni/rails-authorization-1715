class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[ show edit update destroy ]

  # GET /restaurants or /restaurants.json
  def index
    @restaurants = policy_scope(Restaurant).order(:name)
  end

  # GET /restaurants/1 or /restaurants/1.json
  def show
    # authorize @restaurant # `authorize` only checks the permission to show (does not give permission to show)
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
    # raise 'User not authorized' unless current_user == @restaurant.user
    # authorize @restaurant # check_if_user_can_edit? @restaurant
  end

  # POST /restaurants or /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user

    if @restaurant.save
      redirect_to restaurant_url(@restaurant), notice: "Restaurant was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /restaurants/1 or /restaurants/1.json
  def update
    # raise 'User not authorized' unless current_user == @restaurant.user
    
    if @restaurant.update(restaurant_params)
      redirect_to restaurant_url(@restaurant), notice: "Restaurant was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /restaurants/1 or /restaurants/1.json
  def destroy
    # raise 'User not authorized' unless current_user == @restaurant.user
    @restaurant.destroy

    redirect_to restaurants_url, notice: "Restaurant was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
      authorize @restaurant # => raises an error if the user is not allowed to perform the action
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      params.require(:restaurant).permit(:name)
    end
end
