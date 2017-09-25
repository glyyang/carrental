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

    respond_to do |format|
      if @reservation.save
        PickupCheckJob.set(wait_until: @reservation.checkOutTime + 60).perform_later(@reservation.id)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render :show, status: :created, location: @reservation }
        car = Car.find(@reservation.car_id)
        car.update_attributes(:status => "CheckedOut")
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pickup
    @reservation = Reservation.find(params[:id])
    respond_to do |format|
      if @reservation.update_attributes(:pickUpTime => Time.now)
        @reservation.update_attributes(:reservationStatus => "Active")
        ReturnCheckJob.set(wait_until: @reservation.expectedReturnTime + 60).perform_later(@reservation.id)
        format.html { redirect_to @reservation, notice: 'Car was successfully picked up.' }
        format.json { render :show, status: :ok, location: @reservation }
      end
    end
  end

  def return
    @reservation = Reservation.find(params[:id])
    respond_to do |format|
      if @reservation.update_attributes(:returnTime => Time.now)
        @reservation.update_attributes(:reservationStatus => "Complete")
        format.html { redirect_to @reservation, notice: 'Car was successfully returned.' }
        format.json { render :show, status: :ok, location: @reservation }
      end
    end
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    @reservation.update_attributes(:reservationStatus => "Cancel")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:registrationNumber, :checkOutTime, :pickUpTime, :expectedReturnTime, :returnTime, :reservationStatus, :car_id)
    end
  
end
