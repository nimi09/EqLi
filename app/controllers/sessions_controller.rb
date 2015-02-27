class SessionsController < ApplicationController

	before_filter :no_logged_in_user, only: [:new, :create]

	def new
	end

	def create
		user = User.find_by_email(params[:email].downcase)
		if user && user.authenticate(params[:password])
			# log the user in and redirect to the users show page
			log_in user
			redirect_back_or user
		else
			#create an error msg an re render the log in form
			# I not using flash.now[:danger] because i don't re render 'new' instead i redirect_to login_path, so flash.now is not needed in that case
			flash[:danger] = 'Invalid email/password combination'
			redirect_to login_path
		end
	end

	def destroy
		log_out
		redirect_to root_url
	end

end
