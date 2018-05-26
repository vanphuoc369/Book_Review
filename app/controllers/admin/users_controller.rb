module Admin
  class UsersController < AdminController
    before_action :find_user, only: %i(edit update destroy)

    def index
      @users = User.all_users.paginate page: params[:page], per_page: 10
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new user_params
      if @user.save
        flash[:success] = "Thêm tài khoản người dùng thành công."
        redirect_to admin_users_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @user.update_attributes full_name: params[:user][:full_name], activated: params[:user][:activated]
        flash[:success] = "Cập nhật thông tin người dùng thành công."
        redirect_to admin_users_path
      else
        render :edit
      end
    end

    def destroy
      if @user.destroy
        flash[:success] = "Xóa người dùng thành công."
      else
        flash[:danger] = "Xóa người dùng không thành công"
      end
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit :full_name, :email, :password, :password_confirmation, :activated
    end

    def find_user
      @user = User.find_by id: params[:id]
      return if @user
      flash.now[:danger] = "Không tìm thấy người dùng"
      redirect_to admin_users_path
    end
  end
end
