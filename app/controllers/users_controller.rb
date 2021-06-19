class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
    if logged_in?
      @user = User.find(current_user.id)
      render :show
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end


  def show
    if current_user.id == params[:id].to_i
      @user = User.find(params[:id])
    else
      @task = current_user.tasks.created_at
      @task = @task.page(params[:page]).per(5)
      render 'tasks/index'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
