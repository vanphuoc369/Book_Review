module Admin::AdminHelper
  def notification_admin
    @reviews_dont_checked = Review.reviews_dont_checked
  end
end
