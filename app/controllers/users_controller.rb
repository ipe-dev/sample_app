class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    @time = Time.now
  end
  def create
    @user = User.new(user_params)
    if @user.save
      # 登録成功
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      # 登録失敗
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
