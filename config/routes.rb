Rails.application.routes.draw do
  get 'sessions/new'

  get 'users/new'

  root 'dashboard#index'

  resources :bookings
  resources :clients
  resources :users
  resources :owners
  resources :vendors
  resources :locations
  resources :mappings
  resources :lisps
  resources :groups
  resources :subgroups
  resources :assessments
  resources :uploads

  resources :bookings do
    member do
      get 'approve'
      get 'cancel'
      get 'reject'
      get 'accept'
      get 'invoice'
      get 'details_invoice'
    end
    collection do
      post 'find_by_date_and_center'
    end
  end

  resources :sessions do
    collection do
      get 'forgot_password'
    end
  end

  resources :users do
    member do
      get 'add_operator'
      get 'update_password'
    end
  end

  resources :users do
    collection do
      post 'check_if_employee_exists'
    end
  end 

  resources :locations do
    collection do
      post 'check_if_location_exists'
    end
  end

  resources :lisps do
    collection do
      post 'check_if_lisp_exists'
    end
  end 

  
  get 'cities/:state', to: 'application#cities'
  get 'operators/:vendor_id', to: 'application#operators'

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
