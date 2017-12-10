class NotificationsController < ApplicationController
  before_action :authenticate_user!
  after_action :view_notifications, only: :index
  def index
    @notifications = current_user.notification_feed(params[:page])
  end

  def unread_notifications
    @notification_count = { unread: current_user.received_notifications.where(viewed: false).count }.as_json
    respond_to do |format|
      format.html
      format.json { render json: @notification_count }
    end
  end

  private
    def view_notifications
      @notifications.each do |notification|
        notification.view
      end
    end
end
