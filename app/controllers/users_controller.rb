class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :following, :followers]
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    @title = "Following"
    render "show_follow"
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    @title = "Following"
    render "show_follow"
  end


end
