class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin, only: %i[index edit update deactivate]
    before_action :set_user, only: %i[edit update deactivate]
   
    def index
      @users = User.all
    end
   
    def edit
    end
   
    def update
      if @user.update(user_params)
        redirect_to users_path, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end
   
    def deactivate
      @user.update(active: false)
      redirect_to users_path, notice: 'User was successfully deactivated.'
    end
   
    private
   
    def set_user
      @user = User.find(params[:id])
    end
   
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :active)
    end
   
    def check_admin
      redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
    end
  end
  
end
