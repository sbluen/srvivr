Srvivr::Application.routes.draw do

  resources :profiles

  get "welcome/index"

  resources :zombie_sightings

  get "(activity_near_me/(:radius))" => "zombie_sightings#near"

  resources :locations do
    collection do
      get 'map'  # Map a route to the locations controller 'map' function.
    end
  end

  resources :application do
    collection do
      get 'show_friend_invites'
    end
  end
  
  #The last 3 methods are synonyms and are here to reduce short-term programmer memory use. 
  resources :invite do
    collection do
      post 'accept'
      post 'reject'
      post 'refuse'
      post 'decline'
    end
  end

  resources :users
  resources :admin
  resources :profiles do
    collection do
      post 'updatelocation'  # Map a route to the profile controller 'updatelocation' function.
    end
  end
  
  resources :add_friend do
    collection do
      post 'create'
    end
  end
  
  resources :remove_friend do
    collection do
      post 'delete'
    end
  end
  
  resources :report do
    collection do
      post 'create'
    end
  end
  
  resources :edit_my_profile
  resources :remove_friend,  :path_names => { :delete => '/remove_friend'}
  resources :report,  :path_names => { :create => '/report'}
  resources :zombie_handler
  #:path_names => { :create => '/add_friend'}


  # Register routes for the sessions controller.
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  # Register routes for edit_my_profile.
  controller :edit_my_profile do
    put 'edit_my_profile' => :update
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match 'admin' => "Admin#index", :as => "admin"

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
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

