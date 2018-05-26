class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  has_many :comments, dependent: :destroy

  validates :content, presence: {accept: true, message: "không được để trống"}

  scope :newest, -> do
     where("is_check= true").order(created_at: :desc)
  end

  scope :reviews_checked, -> (book_id) do
     where("is_check = ? AND book_id = ?", true, book_id).order(created_at: :desc) if book_id.present?
  end

  scope :find_reviews_to_report, ->(book_id, user_id) do
    where("book_id = ? AND user_id != ?", book_id, user_id) if (book_id.present? && user_id.present?)
  end

  scope :find_reviews_in_year, -> (time_start, time_end) { where(created_at: time_start..time_end) }
end
