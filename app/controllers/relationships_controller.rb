class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    @user = User.find(params[:followed_id])
    @relationship = current_user.follow(@user)
    @relationship.create_notification!(actor_id: current_user.id,
                                       recipient_id: @user.id)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
