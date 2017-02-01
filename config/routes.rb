Rails.application.routes.draw do

  scope "/api",defaults: {format: 'json'} do
      # resources :users, only: [:index, :create, :show, :update]
      # resources :submissions, only: [:index, :create, :show, :update]
      # resources :comments, only: [:index, :create, :show, :update]
      # resources :replies, only: [:index, :create, :show, :update]

      get '/submissions' =>'api/submissions#todas'
      get '/asks' =>'api/submissions#ask'
      get '/submissions/:id' =>'api/submissions#show'

      get '/submissions/user/:id' =>'api/submissions#fromuser'
      post '/submissions' =>'api/submissions#new'
      post '/submissions/:id' =>'api/comments#new' #new comment
      put '/submissions/:id/vote' =>'api/submissions#vote' #new comment

      post '/users/facebook' =>'api/users#createFacebook'
      get '/users/facebook/:apiKey' => 'api/users#existFacebook'

      post '/users/' =>'api/users#create'
      get '/users/:id' => 'api/users#show'
      put '/users/:id' => 'api/users#update' #-->

      get '/comments/:id' =>'api/comments#show'
      get '/comments/user/:id' =>'api/comments#fromuser'
      post '/comments/:id' =>'api/replies#new' #new reply -->
      put '/comments/:id/vote' =>'api/comments#vote' #new comment -->

      get '/replies/:id' => 'api/replies#show'
      get '/replies/user/:id' =>'api/replies#fromuser'
      put '/replies/:id/vote' =>'api/replies#vote' #new comment -->

      get '/threads/user/:id' =>'api/comments#threads'

  end

   resources :authentications
  # #get 'sessions/new'

   get 'signup'  => 'users#new'
   post 'signup'  => 'users#create'
   get   'login' => 'sessions#new'
   post  'login' => 'sessions#create'
   delete   'logout' => 'sessions#destroy'
   get 'ask' => 'submissions#ask'
   get 'threads' => 'comments#threads'


   get '/auth/:provider/callback' => 'authentications#create'


   resources :replies do
     member do
       get "like", to: "replies#upvote"
       get "dislike", to: "replies#downvote"
     end
   end
   resources :comments do
     member do
       get "like", to: "comments#upvote"
       get "dislike", to: "comments#downvote"
     end
   end
   resources :submissions do
     member do
       put "like", to: "submissions#upvote"
       put "dislike", to: "submissions#downvote"
     end
   end
   resources :users
  # # The priority is based upon order of creation: first created -> highest priority.
  # # See how all your routes lay out with "rake routes".

  # # You can have the root of your site routed with "root"
  # # root 'welcome#index'

  # # Example of regular route:
  # #   get 'products/:id' => 'catalog#view'

  # # Example of named route that can be invoked with purchase_url(id: product.id)
  # #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # # Example resource route (maps HTTP verbs to controller actions automatically):
  # #   resources :products

  # # Example resource route with options:
  # #   resources :products do
  # #     member do
  # #       get 'short'
  # #       post 'toggle'
  # #     end
  # #
  # #     collection do
  # #       get 'sold'
  # #     end
  # #   end

  # # Example resource route with sub-resources:
  # #   resources :products do
  # #     resources :comments, :sales
  # #     resource :seller
  # #   end

  # # Example resource route with more complex sub-resources:
  # #   resources :products do
  # #     resources :comments
  # #     resources :sales do
  # #       get 'recent', on: :collection
  # #     end
  # #   end

  # # Example resource route with concerns:
  # #   concern :toggleable do
  # #     post 'toggle'
  # #   end
  # #   resources :posts, concerns: :toggleable
  # #   resources :photos, concerns: :toggleable

  # # Example resource route within a namespace:
  # #   namespace :admin do
  # #     # Directs /admin/products/* to Admin::ProductsController
  # #     # (app/controllers/admin/products_controller.rb)
  # #     resources :products
  # #   end

   resources :submissions do
     post 'comment', on: :member
   end

 resources :comments do
     post 'reply', on: :member
  end

  root 'application#hello'

end
