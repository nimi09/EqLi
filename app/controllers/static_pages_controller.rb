class StaticPagesController < ApplicationController

	before_filter :is_user_admin, only: [:display_row_count]

	def home
	end

	def contact
	end

	def display_row_count
#       Old custom Method => probably not 100% accurate
		@rowcount = User.count + Project.count + AssignedProject.count + AssignedProduct.count + Product.count + Category.count

#       New Method => probaly the correct way to do it
        st=0; ActiveRecord::Base.send(:subclasses).each {|sc| begin; st += sc.all.size unless sc.all.nil?; rescue ActiveRecord::StatementInvalid; end; };
        @trows = st.to_s;
	end

	private

		def is_user_admin
			redirect_to root_url unless current_user.admin?
		end

end
