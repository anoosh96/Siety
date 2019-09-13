class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    if @user && @user.authenticate(params[:session][:password])

       #user authenticated
      if(@user.activated?)
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or(@user)

      else
          message = "Please Activate Your Account First."
          flash[:warning] = message
          redirect_to root_url


       end


    else
      flash.now[:danger] = "Invalid Username or Password"
      render 'new'
    end
  end


  def destroy

     log_out if logged_in?
     redirect_to root_path
  end

end
