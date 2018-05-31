module Admin
  class ReviewsController < AdminController
    before_action :find_review, only: [:show, :update, :destroy]
    def index
      @reviews = Review.all.paginate page: params[:page], per_page: 10
    end

    def show
      @comments = Comment.list_cmt(@review.id)
    end

    def update
      if @review.update_attributes is_check: true
        @activity = Activity.find_by(user_id: @review.user_id, object_id: @review.id)
        @reviews = Review.find_reviews_to_report(@review.book_id, current_user.id)
        if @reviews
          @reviews.each do |review|
            user = User.find_by id: review.user_id
            if user
              Notification.create(user_id: user.id, activity_id: @activity.id,
                content: current_user.full_name + " đã thêm đánh giá cho sách mà bạn đã tham gia đánh giá.")
            end
          end
        end
        flash[:success] = "Duyệt bài đánh giá thành công."
      else
        flash[:danger] = "Duyệt bài đánh giá không thành công."
      end
        redirect_to admin_check_reviews_path
    end

    def destroy
      if @review.destroy
        flash[:success] = "Xóa bài đánh giá thành công."
      else
        flash[:danger] = "Xóa bài đánh giá không thành công."
      end
      redirect_to admin_reviews_path
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
