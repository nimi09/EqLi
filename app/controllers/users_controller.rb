class UsersController < ApplicationController

	before_filter :no_logged_in_user, 	only: [:new, :create]
	before_filter :loged_in_user, 		only: [:index, :show, :edit, :update, :destroy]
	before_filter :correct_user, 		only: [:show, :edit, :update]
	before_filter :is_admin,			only: [:index, :destroy]

	def index
		@users = User.paginate(page: params[:page], :per_page => 30).order("LOWER(name)")
	end

	def show
		@user = User.find(params[:id])
		@projects =  current_user.projects.paginate(page: params[:page], :per_page => 30).order("created_at")
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			#handle a successful save
			log_in @user
			flash[:success] = "Welcome to EqLi!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
#		@user = User.find(params[:id])
# => not needed because of before_filter: correct_user
	end

	def update
#		@user = User.find(params[:id])
# => not needed because of before_filter: correct_user
		if @user.update_attributes(user_params)
			#handle successful update.
			flash[:success] = "Profile updated"
			log_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted."
		redirect_to users_url
	end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

# 		Before filters		

		def loged_in_user
			unless loged_in?
				flash[:warning] = "Please Log in."
				store_location
				redirect_to login_url
			end
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

		def is_admin
			redirect_to(root_url) unless current_user.admin?
		end

end
