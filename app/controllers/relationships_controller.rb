class RelationshipsController < ApplicationController




  def create

    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html  redirect_to @user
      format.js
    end

  end



  def destroy

    @user = User.find(params[:id]).destroy

    current_user.unfollow(@user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end



  end


end
