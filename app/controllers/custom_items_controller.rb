class CustomItemsController < ApplicationController

	before_filter :loged_in_user,   only: [ :new, :create, :edit, :update, :destroy, :addremark, :createremark, :updateremark, :editremark ]
	before_filter :correct_user,  	only: [ :new, :create, :edit, :update, :destroy, :addremark, :createremark, :updateremark, :editremark ]
	before_filter :project_creator, only: [ :new, :create, :edit, :update, :destroy, :addremark, :createremark, :updateremark, :editremark ]

	def show
	end

	def new
		@customitem = CustomItem.new
		@category = Category.find_by_id(params[:category_id])
	end

	def create
		@category = Category.find_by_id(params[:category_id])

		@customitem = CustomItem.new(params[:custom_item])
		@customitem.category_id = @category.id
		@customitem.project_id = @project.id

		if @customitem.save
			flash[:success] = "Added Custom Item"
			redirect_to user_project_path(current_user, @project)
		else
			render 'new'
		end
	end

	def edit
		@customitem = CustomItem.find(params[:id])
		@category = Category.find_by_id(params[:category_id])
	end

	def update
		@category = Category.find_by_id(params[:category_id])

		@customitem = CustomItem.find(params[:id])
		if @customitem.update_attributes(params[:custom_item])
			flash[:success] = "Updated Custom Item: #{@customitem.name}"
			redirect_to user_project_path(current_user, @project)
		else
			render 'edit'
		end
	end

	def destroy
		CustomItem.find(params[:id]).destroy
		flash[:success] = "Custom Item deleted."
		redirect_to user_project_path(current_user, @project)
	end

######################################################################################
# Custom Mehtods

	def addremark
		@category = Category.find_by_id(params[:category_id])
		@customitem = CustomItem.find(params[:customitem_id])
	end

	def createremark
		@category = Category.find_by_id(params[:category_id])
		@customitem = CustomItem.find(params[:customitem_id])
		oldremark = @customitem.remark

		if @customitem.update_attributes(remark: params[:custom_item][:remark])
			if @customitem.remark.length > 0
				flash[:success] = "Added remark."
			end
			redirect_to user_project_path(current_user, @customitem.project)
		else
			@customitem.assign_attributes(remark: oldremark)
			render 'addremark'
		end		
	end

	def updateremark
		@category = Category.find_by_id(params[:category_id])
		@customitem = CustomItem.find(params[:customitem_id])
		oldremark = @customitem.remark

		if @customitem.update_attributes(remark: params[:custom_item][:remark])
			flash[:success] = "Updated remark."
			redirect_to user_project_path(current_user, @customitem.project)
		else
			@customitem.assign_attributes(remark: oldremark)
			render 'editremark'
		end		
	end

	def editremark
		@category = Category.find_by_id(params[:category_id])
		@customitem = CustomItem.find(params[:customitem_id])
	end

	def destroyremark
		@customitem = CustomItem.find(params[:customitem_id])
		if @customitem.update_attributes(remark: "")
			flash[:success] = "Deleted remark."
			redirect_to user_project_path(current_user, @customitem.project)
		else
			flash[:success] = "Something went wrong."
			redirect_to user_project_path(current_user, @customitem.project)
		end
	end


######################################################################################
# Private Stuff
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
			@project = Project.find_by_id(params[:project_id])
			redirect_to root_url unless current_user.id == @project.creator_id
		end	

end
