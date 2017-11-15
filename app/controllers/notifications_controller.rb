class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @notifications = current_user.notification_feed(params[:page])
  end
end
