class ReservationsController < ApplicationController
  
  require 'date'
  Time.zone = 'Eastern Time (US & Canada)'
  
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show, :edit, :index, :new, :create, :pickup, :returncar, :cancel, :destroy]
  before_action :logged_in_as_admin, only: [:destroy]

  # GET /reservations
  # GET /reservations.json
  def index
    if isAdmin? || isSuperAdmin?
      @reservations = Reservation.all
    else
      @reservations = Reservation.where(:user_id => session[:user_id]) || [] # return current user record or empty
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    # param1 = params[:param1]
    @reservation = Reservation.new
    # @reservation.update_attribute(:car_id, param1)
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    car_id = reservation_params[:car_id]
    user_id = reservation_params[:user_id]
    if user_id==""
      flash[:danger] = "You should select a user."
      redirect_to new_reservation_path(:param1 => car_id)
      return
    end
    unless Car.find(car_id).status == "Available"
      flash[:danger] = "This car is not available."
      redirect_to cars_path
      return
    end
    user = User.find(user_id)
    if user.available
      @reservation = Reservation.new(reservation_params)
      if @reservation.save
        flash[:success] = 'Reservation was successfully created.'
        PickupCheckJob.set(wait_until: @reservation.checkOutTime + 30.minutes).perform_later(@reservation.id)
        redirect_to @reservation
        car = Car.find(@reservation.car_id)
        car.update_attribute(:status, "Reserved")
        user.update_attribute(:available, false)
      else
        if @reservation.errors.any?
          @reservation.errors.full_messages.each do |message|
            flash[:errors] = message
          end
        end
        redirect_to new_reservation_path(:param1 => car_id)
      end
    else
      flash[:danger] = "You have a car in hold, and cannot reserve another car until you return it."
      redirect_to user
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
    User.find(@reservation.user_id).update_attribute(:available, true)
    Car.find(@reservation.car_id).update_attribute(:status, "Available")
    @reservation.destroy
    flash[:success] = 'Reservation deleted!'
    redirect_to reservations_url
  end

  def pickup
    @reservation = Reservation.find(params[:id])
    if @reservation.checkOutTime > Time.now
      flash[:error] = 'You need to wait to pick up the car!'
      redirect_to @reservation
    elsif @reservation.update_attribute(:pickUpTime, Time.now)
      flash[:success] = 'Car was successfully picked up. Have a good time!'
      @reservation.update_attribute(:reservationStatus, "Active")
      car = Car.find(@reservation.car_id)
      car.update_attribute(:status, "CheckedOut")
      ReturnCheckJob.set(wait_until: @reservation.expectedReturnTime + 60).perform_later(@reservation.id)
      redirect_to @reservation
    end
  end

  def returncar
    @reservation = Reservation.find(params[:id])
    if @reservation.update_attribute(:returnTime, Time.now)
      flash[:success] = 'Car was successfully returned. Thank you!'
      @reservation.update_attribute(:reservationStatus, "Complete")
      user = User.find(@reservation.user_id)
      car = Car.find(@reservation.car_id)
      car.update_attribute(:status, "Available")
      price = car.hourlyRentalRate
      hold_time = (@reservation.returnTime - @reservation.pickUpTime)/3600.0 # convert to hours
      charge = user.rentalCharge + price*hold_time
      user.update_attribute(:rentalCharge, charge) 
      # user.update_attribute(:notification, "You have pending charge!")
      user.update_attribute(:available, true)
      redirect_to @reservation
    end
  end

  # PATCH/PUT /reservations/1
  def cancel
    @reservation = Reservation.find(params[:id])
    if ["Active", "Complete", "Cancel"].include? @reservation.reservationStatus
      flash[:danger] = "Reservation cannot be canceled!"
      redirect_to reservations_url
      return
    end
    if @reservation.update_attribute(:reservationStatus, "Cancel")
      User.find(@reservation.user_id).update_attribute(:available, true)
      Car.find(@reservation.car_id).update_attribute(:status, "Available")
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
