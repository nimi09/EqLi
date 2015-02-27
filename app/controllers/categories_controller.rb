class CategoriesController < ApplicationController

	before_filter :is_loged_in_and_admin, 	only: [:index, :show, :new, :create, :edit, :update, :destroy]

	def index
		@category = nil
		@categories = Category.order("id ASC").find(:all, :conditions => {:parent_id => nil } )
  	end

	# Show subcategory
	def show
		# Find the category belonging to the given id
		@category = Category.find(params[:id])
		# Grab all sub-categories
		@categories = @category.subcategories.order("name ASC")
		# We want to reuse the index renderer:
		render 'index'
	end

	def new
		@category = Category.new
		@category.parent_id = params[:id] unless params[:id].nil?
	end

	def create
		@category = Category.new(params[:category])

		if @category.save
			# Handle success
			flash[:success] = "Category successful created."
			redirect_to @category.parent_id.nil? ? categories_path : category_path(@category.parent_id)
		else
			render 'new'
		end
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find_by_id(params[:id])

		if @category.update_attributes(params[:category])
			flash[:success] = "Category updated."
			redirect_to @category.parent_id.nil? ? categories_path : category_path(@category.parent_id)
		else
			render 'edit'
		end
	end

	def destroy
		cat_to_del = Category.find(params[:id])
		redirect_id = cat_to_del.parent_id
		cat_to_del.destroy
		flash[:success] = "Category deleted."
		redirect_to redirect_id.nil? ? categories_path : category_path(redirect_id)
	end

	private

		def is_loged_in_and_admin
			if loged_in? 
				redirect_to root_url unless current_user.admin?
			else
				redirect_to root_url
			end
		end

end
