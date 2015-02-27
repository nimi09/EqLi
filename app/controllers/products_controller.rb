class ProductsController < ApplicationController

	before_filter :is_loged_in_and_admin, only: [:index, :show, :new, :create, :edit, :update, :destroy]

	def index
		@products = Product.paginate(page: params[:page], per_page: 30).order('name ASC')
	end

	def show
		@product = Product.find_by_id(params[:id])
	end

	def new
		@product = Product.new
		@product.assign_attributes( {category_id: params[:category_id]} ) if params[:category_id]
	end

	def create
		@product = Product.new(params[:product])
		if @product.save
			# Handle success
			flash[:success] = "Added Product: #{@product.name}"
			redirect_to products_path
		else
			render 'new'
		end
	end

	def edit
		@product = Product.find_by_id(params[:id])
	end

	def update
		@product = Product.find_by_id(params[:id])
		if @product.update_attributes(params[:product])
			# Handle success
			flash[:success] = "Updated Product: #{@product.name}"
			redirect_to products_path
		else
			render 'edit'
		end
	end

	def destroy
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
