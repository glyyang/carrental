class CarsController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :edit, :update, :destroy]
  
  # GET /cars
  # GET /cars.json
  def index
    # @cars = Car.search(params).paginate(page: params[:page])
    @q = Car.ransack(params[:q])
    @cars = @q.result().paginate(page: params[:page])
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
    @car = Car.find(params[:id])
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
    @car = Car.find(params[:id])
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = Car.new(car_params)
    if @car.save
      flash[:success] = "New car added!"
      redirect_to @car
    else
      render :new
    end
  end

  # PATCH/PUT /cars/1
  # PATCH/PUT /cars/1.json
  def update
    @car = Car.find(params[:id])
    if @car.update_attributes(car_params)
      flash[:sucess] = "Car info updated."
      redirect_to @car
    else
      render :edit
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    @car = Car.find(params[:id]).destroy
    flash[:success] = 'Car deleted.'
    redirect_to cars_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_car
    #   @car = car.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_params
      params.require(:car).permit(:licensePlateNumber, :manufacturer, :model, :hourlyRentalRate, :style, :location, :status)  
    end
    
    # # Confirms a logged-in user.
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #   end
    # end
    
end
