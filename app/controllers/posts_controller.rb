class PostsController < ApplicationController
  before_action :authenticate_user! 
  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post successfully created"
      redirect_to root_path
    else
      render 'static_pages/home'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "Post successfully destroyed"
    redirect_to root_path
  end

  private
    def post_params
      params.require(:post).permit(:content)
    end
end