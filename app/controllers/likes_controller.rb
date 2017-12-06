class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.create!(like_params)
    @like.create_notification!(actor_id: current_user.id,
                               recipient_id: @like.likeable.user.id)
    @likeable = @like.likeable
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    @like = Like.find_by(like_params)
    current_user.likes.destroy(@like)
    @likeable = @like.likeable
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private
    def like_params
      params.require(:like).permit(:likeable_id, :likeable_type)
    end

end
