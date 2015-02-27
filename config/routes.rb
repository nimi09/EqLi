Eqli::Application.routes.draw do

  get "custom_items/show"

  get "custom_items/new"

  get "custom_items/create"

  get "custom_items/edit"

  get "custom_items/update"

  get "custom_items/destroy"

  get "remarks/new"

  get "remarks/create"

	resources :products

	resources :categories do
    resources :products, only: [:new]
  end

	resources :users do
		resources :projects do
			member do
				get 'add'

				match '/add/:categoryid',								to: 'projects#add',										via: 'get'
				match '/assignproduct/:pid/cat/:cid',		to: 'projects#assignproduct',					via: 'post'

				match '/assignallproducts',							to: 'projects#assignallproducts',			via: 'post'

				match '/delete/:pid',										to: 'projects#deleteassignedproduct', via: 'delete'

				match '/print',													to: 'projects#print',									via: 'get'

        match '/cloneproject',                  to: 'projects#cloneproject',          via: 'get'
        match '/rename',                        to: 'projects#renamecloneproject',    via: 'get'
        match '/rename',                        to: 'projects#updaterenamecloneproject', via: 'put'

				match '/newremark/:pid',								to: 'remarks#new',										via: 'get'
				match '/newremark/:pid',								to: 'remarks#create',									via: 'post'
				match '/remark/:pid/edit',							to: 'remarks#edit',										via: 'get'
				match '/remark/:pid/update',						to: 'remarks#update',									via: 'put'
				match '/deleteremark/:pid',							to: 'remarks#destroy',								via: 'delete'

#        match '/:cid/custom/new',               to: 'custom_items#new',               via: 'get'
				
			end
#      resources :custom, controller: 'custom_items'
      resources :categories do
        resources :customitem, controller: 'custom_items' do
          match '/addremark',     to: 'custom_items#addremark',     via: 'get'
          match '/createremark',  to: 'custom_items#createremark',  via: 'put'
          match '/updateremark',  to: 'custom_items#updateremark',  via: 'put'
          match '/editremark',    to: 'custom_items#editremark',    via: 'get'
          match '/destroyremark', to: 'custom_items#destroyremark', via: 'delete'
        end
      end
	  end
	end

	resources :sessions, only: [:new, :create, :destroy]

	match '/signup',  to: 'users#new'
	match '/login',   to: 'sessions#new'
	match 'logout',   to: 'sessions#destroy', via: :delete

	match '/contact', 					to: 'static_pages#contact'
	match '/display_row_count', to: 'static_pages#display_row_count'

	root to: 'static_pages#home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
