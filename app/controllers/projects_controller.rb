class ProjectsController < ApplicationController

	before_filter :loged_in_user, 	only: [:new, :create, :edit, :update, :show, :cloneproject, :renamecloneproject, :updaterenamecloneproject, :add, :assignproduct, :deleteassignedproduct, :print]
	before_filter :correct_user, 	only: [:new, :create, :edit, :update, :show, :cloneproject, :renamecloneproject, :updaterenamecloneproject, :add, :assignproduct, :deleteassignedproduct, :print]
	before_filter :project_creator,	only: [				  :edit, :update, 		 :cloneproject, :renamecloneproject, :updaterenamecloneproject, :add, :assignproduct, :deleteassignedproduct, :print]

	def show
		@project = Project.find(params[:id])
		@maincategories = Category.where("parent_id is ?", nil).order("id ASC").all
		@products = @project.products.order("category_id ASC, name ASC")
	end

	def new
		@project = Project.new
		@project.assigned_projects.build(user_id: current_user)
	end

	def create
		@project = Project.new(params[:project])
		@project.creator_id = current_user.id

		if @project.save
			@project.assigned_projects.create(user_id: current_user.id)
			flash[:success] = "Added new project: #{@project.title}"
			redirect_to current_user
		else
			@project.assigned_projects.build(user_id: current_user)
			render 'new'
		end
	end

	def edit
#		is done in BEFORE_FILTER: project_creator
#		@project = Project.find_by_id(params[:id])
	end

	def update
#		is done in BEFORE_FILTER: project_creator
#		@project = Project.find_by_id(params[:id])

		if @project.update_attributes(params[:project])
			# Handle successfull upadet
			flash[:success] = "Project updated."
			redirect_to user_path(current_user)
		else
			@projecttitle = Project.find_by_id(@project.id).title
			render 'edit'
		end
	end

# CUSTOM FUNCTIONS ############################################################################

	def cloneproject
		new_project = @project.dup
		new_project.title += "-CLONE"

		if new_project.save
			new_project.assigned_projects.create(user_id: current_user.id)
			@project.assigned_products.each do |ap|
				nap = ap.dup
				nap.update_attributes(project_id: new_project.id) 
			end
			flash[:success] = "Projecd cloned successfull."
			redirect_to rename_user_project_path(current_user, new_project)
		else
			flash[:danger] = "Something went wrong."
			redirect_to current_user
		end

	end

	def renamecloneproject
	end

	def updaterenamecloneproject
#		is done in BEFORE_FILTER: project_creator
#		@project = Project.find_by_id(params[:id])
		if @project.update_attributes(params[:project])
			# Handle successfull upadet
			flash[:success] = "Project updated."
			redirect_to user_path(current_user)
		else
			@projecttitle = Project.find_by_id(@project.id).title
			render 'renamecloneproject'
		end
	end

	def assignallproducts
		error = false

		params[:products].each do |p|
			assignedproduct = AssignedProduct.where("project_id = ?", params[:id]).where("product_id = ?", p[0]).first()
			if assignedproduct
				if params[:products][p[0]][:quantity].to_i > 0 
					assignedproduct.update_attributes(quantity: params[:products][p[0]][:quantity])
					if not assignedproduct.save
						error = true
					end
				elsif params[:products][p[0]][:quantity].to_i <= 0
					assignedproduct.delete
				end
			else
				if params[:products][p[0]][:quantity].to_i > 0
					assignedproduct = AssignedProduct.new
					assignedproduct.attributes = { project_id: params[:id], product_id: p[0], quantity: params[:products][p[0]][:quantity] }

					if not assignedproduct.save
						error = true
					end

				end
			end
		end

		if error
			flash[:danger] = "Something went wrong!"
		else
			flash[:success] = "Saved changes."
		end

		redirect_to add_user_project_path(params[:user_id], params[:id]) + "/" + params[:project][:category_id]
	end

	def add
		@maincategories = Category.where("parent_id is ?", nil).order("id ASC").all
		@current_category = Category.find_by_id(params[:categoryid]) if params[:categoryid]
		@products = Product.where(category_id: params[:categoryid]).order("name ASC").all if @current_category
	end

	def assignproduct

		assigned_product = AssignedProduct.where("project_id = ?", params[:id].to_i).where("product_id = ?", params[:pid].to_i).first

		if assigned_product == nil then
			assigned_product = AssignedProduct.new
			assigned_product.attributes = { project_id: params[:id], product_id: params[:pid], quantity: 1 }
#			assigned_product.project_id = params[:id]
#			assigned_product.product_id = params[:pid]
#			assigned_product.quantity = 1
		else
			assigned_product.quantity += 1
		end

		if assigned_product.save
			flash[:success] = "Added #{Product.find_by_id(params[:pid]).name}"
			redirect_to add_user_project_path(current_user, params[:id]) + "/" + params[:cid]
		else
			flash[:danger] = "something went wrong"
			redirect_to add_user_project_path(current_user, params[:id]) + "/" + params[:cid]
		end

	end

	def deleteassignedproduct
		if AssignedProduct.where("project_id = ?", @project.id).where("product_id = ?", params[:pid]).first.delete
			flash[:success] = "Item deleted!"
		else
			flash[:danger] = "Something went wrong."
		end
		redirect_to user_project_path(current_user, @project)
	end

	def print
		@project = Project.find(params[:id])
		@maincategories = Category.where("parent_id is ?", nil).order("id ASC").all
		@products = @project.products.order("category_id ASC, name ASC")		
	end


# PRIVATE FUNCTIONS ############################################################################

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
