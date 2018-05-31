module Admin::CheckReviewsHelper
  def find_user_reviewed review_id
    @review_of_user = Review.find_by id: review_id
    @user = User.find_by id: @review_of_user.user_id
  end
end
