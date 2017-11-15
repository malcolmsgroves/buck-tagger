class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      @comment.create_notification!(actor_id: current_user.id,
                                    recipient_id: @comment.post.user.id)
      flash[:success] = "Comment successfully created"
      redirect_to root_path
    else
      render 'static_pages/home'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:success] = "Comment successfully destroyed"
    redirect_to root_path
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :post_id)
    end
end
