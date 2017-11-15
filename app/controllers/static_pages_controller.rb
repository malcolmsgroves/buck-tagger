class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  def home
    @post = current_user.posts.build
    @feed_items = current_user.feed.paginate(page: params[:id])
  end

  def help
  end

  def about
  end
end
