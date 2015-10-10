Rails.application.routes.draw do

  root             'static_pages#home'
  #creates routes such as help_path 
  get     'help'    =>  'static_pages#help'
  get     'about'   =>  'static_pages#about'
  get     'contact' =>  'static_pages#contact'
  get     'signup'  =>  'users#new'
  #  creates RESTful routes for interacting with User resource
  #
  #  HTTP   |  URL                 |  Action     |  Named Route             |  Purpose
  #  -------------------------------------------------------------------------------------------------
  #  GET    |  /users              |  index      | users_path               | page to list all users
  #  GET    |  /users/id           |  show       | user_path(user)          | page to show user
  #  GET    |  /users/new          |  new        | new_user_path            | page to make new user
  #  POST   |  /users              |  create     | users_path               | action to create a new user
  #  GET    |  /users/id/edit      |  edit       | edit_user_path(user)     | page to edit a user
  #  PATCH  |  /users/id           |  update     | user_path(user)          | action to update user
  #  DELETE |  /users/id           |  destroy    | user_path(user)          | action to delete user
  #  GET    |  /users/id/followers |  followers  | followers_user_path(id)  | show user's followers
  #  GET    |  /users/id/following |  following  | following_user_path(id)  | show user's follows
  #  -------------------------------------------------------------------------------------------------
  resources :users do 
    member do 
      get :following, :followers
    end
  end
  get     'login'   =>  'sessions#new'
  post    'login'   =>  'sessions#create'
  delete  'logout'  =>  'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]


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
