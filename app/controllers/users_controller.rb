class UsersController < ApplicationController
  include UsersHelper
  
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:index, :edit, :update]
  before_action :logged_in_as_admin, only: [:index]

  # GET /users
  # GET /users.json
  def index
    # @users = User.search(params).paginate(page: params[:page])
    @q_users = User.ransack(params[:q])
    @users = @q_users.result().paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      if logged_in?
        flash[:success] = "New user account created!"
      else
        log_in @user
        flash[:success] = "Welcome to Car Rental App!"
      end
      redirect_to @user
    else
      flash[:danger] = "Failed to sign up"
      render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:sucess] = "Profile updated."
      redirect_to @user
    else
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = 'User deleted.'
    redirect_to users_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_user
    #   @user = User.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :rentalCharge, :notification, :available)
    end
    
    # Before filters

    # # Confirms a logged-in user.
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #   end
    # end
    
    # # Confirms the correct user.
    # def correct_user
    #   @user = User.find(session[:user_id])
    #   # @user = User.find(params[:id])
    #   redirect_to(root_url) unless current_user?(@user)
    # end
    
end
