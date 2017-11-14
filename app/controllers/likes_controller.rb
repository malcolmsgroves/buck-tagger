class LikesController < ApplicationController

  def create
    current_user.likes.create(like_params)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    @like = Like.find_by(like_params)
    current_user.likes.delete(@like)
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
