class ReservationsController < ApplicationController
  
  require 'date'
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  Time.zone = 'Eastern Time (US & Canada)'

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    param1 = params[:param1]
    @reservation = Reservation.new
    @reservation.update_attributes(:car_id => param1)
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      flash[:success] = 'Reservation was successfully created.'
      PickupCheckJob.set(wait_until: @reservation.checkOutTime + 60).perform_later(@reservation.id)
      redirect_to @reservation
      car = Car.find(@reservation.car_id)
      car.update_attributes(:status => "CheckedOut")
    else
      render :new
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    if @reservation.update(reservation_params)
      flash[:success] = 'Reservation was successfully updated.'
      redirect_to @reservation
    else
      render :edit
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    flash[:success] = 'Reservation deleted!'
    redirect_to reservations_url
  end

  def pickup
    @reservation = Reservation.find(params[:id])
    if @reservation.update_attributes(:pickUpTime => Time.now)
      flash[:success] = 'Car was successfully picked up. Have a good time!'
      @reservation.update_attributes(:reservationStatus => "Active")
      ReturnCheckJob.set(wait_until: @reservation.expectedReturnTime + 60).perform_later(@reservation.id)
      redirect_to @reservation
    end
  end

  def returncar
    @reservation = Reservation.find(params[:id])
    if @reservation.update_attributes(:returnTime => Time.now)
      flash[:success] = 'Car was successfully returned. Thank you!'
      @reservation.update_attributes(:reservationStatus => "Complete")
      @user = User.find(@reservation.user_id)
      @car = Car.find(@reservation.car_id)
      @car.update_attributes(:status => "Available")
      price = @car.hourlyRentalRate
      hold_time = (@reservation.returnTime - @reservation.pickUpTime).hour
      charge = @user.rentalCharge + price*hold_time
      @user.update_attributes(:rentalCharge => charge, :notification => "You have pending charge!")
      redirect_to @reservation
    end
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    if @reservation.update_attributes(:reservationStatus => "Cancel")
      flash[:success] = "Reservation successfully canceled!"
      redirect_to @reservation
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:registrationNumber, :checkOutTime, :pickUpTime, :expectedReturnTime, :returnTime, :reservationStatus, :user_id, :car_id)
    end
  
end
