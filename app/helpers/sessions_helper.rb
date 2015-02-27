module SessionsHelper

	def log_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.digest(remember_token))
		self.current_user = user
	end

	def loged_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by_remember_token(remember_token)
	end

	def current_user?(user)
		user == current_user
	end

	def log_out
		current_user.update_attribute(:remember_token, User.digest(User.new_remember_token)) unless current_user.nil?
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url
	end

############################################################
	# from User_Controller now available in all controllers!
	# Before filters

	def no_logged_in_user
		if loged_in?
			flash[:warning] = "You are already loged in with an account!"
			redirect_to root_url
		end
	end

end
