module Admin
  class CheckReviewsController < AdminController
    before_action :find_review, only: [:show, :destroy]

    def index
      @reviews_dont_checked = Review.reviews_dont_checked.paginate page: params[:page], per_page: 10
    end

    def show
    end

    def destroy
      if @review.destroy
        @activity = Activity.create(user_id: @review.user_id, type_activity: "book",
          content: "Viết bài đánh giá không hợp lệ cho sách", object_id: @review.book_id)
        Notification.create(user_id: @review.user_id, activity_id: @activity.id,
          content: "Bài đánh giá sách của bạn có chứa một số nội dung không phù hợp.
           Vui lòng cân nhắc trước khi đánh giá sách nếu không tài khoản của bạn sẽ bị hủy không báo trước.")
        flash[:success] = "Hủy bài đánh giá thành công."
      else
        flash[:danger] = "Hủy bài đánh giá không thành công."
      end
      redirect_to admin_check_reviews_path
    end

    private

    def find_review
      @review = Review.find_by id: params[:id]
      return if @review
      flash[:danger] = "Không tìm thấy bài đánh giá"
      redirect_to admin_reviews_path
    end
  end
end
