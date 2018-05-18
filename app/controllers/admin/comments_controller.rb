class Admin::CommentsController < ApplicationController
  def show
    @review_id = (Comment.find_by id: params[:id]).review_id
    @reply_comments = Comment.list_reply_cmt(@review_id, params[:id])
    @reply_comment_id = params[:id]
    respond_to do |format|
      format.html
      format.js
    end
  end
  def destroy
    @comment = Comment.find_by id: params[:id]
    @review_id = @comment.review_id
    if @comment.destroy
      flash.now[:success] = "Xóa bình luận thành công"
    else
      flash.now[:danger] = "Xóa bình luận không thành công"
    end
    @comments = Comment.list_cmt(@review_id)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
