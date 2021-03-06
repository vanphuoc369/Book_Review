module Admin
  class BooksController < AdminController
    before_action :find_book, except: %i(index new create)

    def index
      @books = Book.new_book.paginate page: params[:page], per_page: 10
    end

    def new
      @book = Book.new
    end

    def create
      @book = Book.new book_params
      if @book.save
        flash[:success] = "Thêm sách mới thành công"
        redirect_to admin_books_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @book.update_attributes book_params
        flash[:sucess] = "Cập nhật sách thành công"
        redirect_to admin_books_path
      else
        render :edit
      end
    end

    def destroy
      if @book.destroy
        flash[:success] = "Xóa sách thành công"
      else
        flash[:danger] = "Xóa sách không thành công"
      end
      redirect_to admin_books_path
    end

    private

    def book_params
      params.require(:book).permit :title, :author, :image, :publish_date, :number_of_pages, :summary
    end

    def find_book
      @book = Book.find_by id: params[:id]
      return if @book
      flash[:danger] = "Không tìm thấy sách"
      redirect_to admin_books_path
    end
  end
end
