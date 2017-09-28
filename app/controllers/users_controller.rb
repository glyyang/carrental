class UsersController < ApplicationController
<<<<<<< HEAD
  before_action :set_user, only: [:show, :edit, :create_and_update, :destroy]
=======
  include UsersHelper
  
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:index, :edit, :update]
  before_action :logged_in_as_admin, only: [:index]
>>>>>>> 7aeb37be93b12094686fdafe4bcbee0d54f2379b

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
<<<<<<< HEAD
    @user = User.find(user_params)
=======
    @user = User.find(params[:id])
>>>>>>> 7aeb37be93b12094686fdafe4bcbee0d54f2379b
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
<<<<<<< HEAD
    @user = User.find(user_params)
=======
    @user = User.find(params[:id])
>>>>>>> 7aeb37be93b12094686fdafe4bcbee0d54f2379b
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
<<<<<<< HEAD
  def create_and_update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        @user = User.new(user_params)
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
=======
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:sucess] = "Profile updated."
      redirect_to @user
    else
      render :edit
>>>>>>> 7aeb37be93b12094686fdafe4bcbee0d54f2379b
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
