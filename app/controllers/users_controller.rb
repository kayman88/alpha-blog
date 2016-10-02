class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update , :show, :destroy]
  before_action :require_user,  only: [:edit,:update]
  before_action :require_same_user, only: [:edit,:update, :destroy]
  before_action :requiere_admin, only: [:destroy]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the jungle blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  def edit
    
  end
  
  def update
     if @user.update(user_params)
       flash[:success] = "Ypur account was successfully updated"
       redirect_to articles_path
     else
       render 'edit'
     end
     
  end
  
  def show
    @user_articles = @user.articles.paginate(page: params[:page],per_page: 2)
  end
  
  def index
    @users  = User.paginate(page: params[:page], per_page: 2)
  end
  
  def destroy
    @user.destroy
    flash[:danger] ="User and all articles have been deleted"
    redirect_to users_path
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:username,:email,:password)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "You can only edit your own profile"
      redirect_to root_path
    end
  end
  
  def requiere_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Only Admin can perform this action"
      redirect_to root_path
    end
  end
end
