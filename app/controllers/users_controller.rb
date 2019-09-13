class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy



 def index

   @users = User.where(activated: true).paginate(page: params[:page], per_page: params[:per_page])

 end



  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end


  def create

     @user = User.new(user_params)   #not full implementation
     if @user.save
        # Handle a successful save.
       @user.sendActivationEmail
       #send activation link to user
       flash[:info] = "Check Email to activate your account"
       redirect_to root_url
    else
       render 'new'
    end
  end

 def edit
    @user = User.find(params[:id])
 end

 def destroy

    @user = User.find(params[:id]).destroy
    flash[:sucess] = "User Deleted successfully"
    redirect_to users_path
 end

 def update
   @user = User.find(params[:id])
    if @user.update_attributes(user_params)
       #edited successfully
       flash[:success] = "Changes Saved"
       redirect_to @user
    else
       render 'edit'

   end
end


   # Confirms a logged-in user. def logged_in_user
   def logged_in_user

   unless logged_in?
     flash[:danger] = "Please log in."
     store_location
     redirect_to login_url
   end
 end

 def correct_user

   @user = User.find(params[:id])
   unless @user == current_user
     redirect_to root_url

 end

end

def admin_user

   redirect_to root_url unless current_user.admin?

end




  private
     def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
     end


end
