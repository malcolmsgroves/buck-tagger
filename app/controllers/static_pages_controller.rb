class StaticPagesController < ApplicationController
  def home
    @post = current_user.posts.build
    @feed_items = current_user.feed.paginate(page: params[:id])
  end

  def help
  end

  def about
  end
end
