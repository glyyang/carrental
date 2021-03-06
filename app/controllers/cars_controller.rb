class CarsController < ApplicationController
  include CarsHelper
  before_action :logged_in_user, only: [:index, :new, :show, :edit, :update, :destroy]
  before_action :logged_in_as_admin, only: [:new, :destroy, :edit, :update]
  
  # GET /cars
  # GET /cars.json
  def index
    @q_cars = Car.ransack(params[:q])
    @cars = @q_cars.result().paginate(page: params[:page])
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
<<<<<<< HEAD
    @car = Car.find(params[:model])
=======
    @car = Car.find(params[:id])
>>>>>>> 7aeb37be93b12094686fdafe4bcbee0d54f2379b
  end

  # GET /cars/new
  # this should redirect to create html
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
<<<<<<< HEAD
    @car = Car.find(params[:licensePlateNumber])
    @car.status = params[:status]
=======
    @car = Car.find(params[:id])
>>>>>>> 7aeb37be93b12094686fdafe4bcbee0d54f2379b
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
    
end
