class LikesController < ApplicationController

  def create
    current_user.likes.create!(like_params)
    flash[:success] = "You liked the post"
    redirect_to root_path
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "You unliked the post"
    redirect_to root_path
  end

  private
    def like_params
      params.require(:like).permit(:content)
    end

end
