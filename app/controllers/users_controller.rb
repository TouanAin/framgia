class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  def new
  	@user = User.new
  end
  
  def create
  	@user = User.new(user_params)
  	if @user.save
  	  flash[:success] = "Welcome to blog demo!"
      log_in @user
  	  redirect_to @user
  	else
  	  render 'new'
  	end
  end
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page], :per_page => 4)
  end
  
  def show
  	@user = User.find(params[:id])
    @entries = @user.entries.paginate(page: params[:page], :per_page => 4 )
  end
  


  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page],:per_page => 4)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page],:per_page => 4)
    render 'show_follow'
  end
  # def your_follow
  #   @users = current_user.following.all
  # end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
