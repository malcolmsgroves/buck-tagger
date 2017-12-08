class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  def home
    @post           = current_user.posts.build
    @deer           = @post.build_deer
    @season_options = [nil, 'rifle', 'archery', 'muzzleloader', 'youth']
    @sex_options    = [nil, 'buck', 'doe']
    @feed_items     = current_user.feed.paginate(page: params[:id])
    @location       = current_user.last_location
  end

  def help
  end

  def about
  end
end
