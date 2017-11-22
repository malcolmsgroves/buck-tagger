class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  def home
    @post = current_user.posts.build
    @deer = @post.build_deer
    @season_options = ['rifle', 'archery', 'muzzleloader', 'youth']
    @sex_options = ['buck', 'doe']
    @county_options = County.all.collect {|c| [c.name, c.id]}
    @feed_items = current_user.feed.paginate(page: params[:id])
  end

  def help
  end

  def about
  end
end
