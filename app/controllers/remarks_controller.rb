class RemarksController < ApplicationController

	before_filter :loged_in_user, 	only: [ :new, :create, :edit, :update, :destroy ]
	before_filter :correct_user, 	only: [ :new, :create, :edit, :update, :destroy ]
	before_filter :project_creator,	only: [ :new, :create, :edit, :update, :destroy ]

	def new
		@product = Product.find_by_id(params[:pid])
		@ap = @product.assigned_products.where("project_id = ?", @project.id).first
	end

	def create
		ap = AssignedProduct.where("project_id = ?", params[:id]).where("product_id = ?", params[:pid]).first

		if ap.update_attributes(remarks: params[:remarks])
			flash[:success] = "Remark added."
			redirect_to user_project_path(current_user, params[:id])
		else
			flash[:danger] = "Something went wrong."
			redirect_to user_project_path(current_user, params[:id])
		end
	end

	def edit
		@product = Product.find_by_id(params[:pid])
		@ap = @product.assigned_products.where("project_id = ?", @project.id).first
	end

	def update
		ap = AssignedProduct.where("project_id = ?", params[:id]).where("product_id = ?", params[:pid]).first

		if ap.update_attributes(remarks: params[:assigned_product][:remarks])
			flash[:success] = "Remark updated."
			redirect_to user_project_path(current_user, params[:id])
		else
			flash[:danger] = "Something went wrong."
			redirect_to user_project_path(current_user, params[:id])
		end
	end

	def destroy
		ap = AssignedProduct.where("project_id = ?", params[:id]).where("product_id = ?", params[:pid]).first
		if ap.update_attributes(remarks: nil)
			flash[:success] = "Remark deleted."
			redirect_to user_project_path(current_user, params[:id])
		else
			flash[:danger] = "Something went wrong."
			redirect_to user_project_path(current_user, params[:id])
		end
	end

	private

		def loged_in_user
			unless loged_in?
				flash[:warning] = "Please Log in."
				store_location
				redirect_to login_url
			end
		end

		def correct_user
			@user = User.find(params[:user_id])
			redirect_to(root_url) unless current_user?(@user)
		end

		def project_creator
			@project = Project.find_by_id(params[:id])
			redirect_to root_url unless current_user.id == @project.creator_id
		end

end
