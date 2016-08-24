Rails.application.routes.draw do
  get 'authentication/status'

  get 'authentication/redirect_target'

  mount ActionCable.server => '/cable'

  get 'users/username'
  post 'users/username', to: "users#set_username"

  get 'review', to: "review#index"
  post 'review/feedback', to: "review#add_feedback"

  get 'stack_exchange_users/index'
  get 'stackusers/:id', to: "stack_exchange_users#show", as: "stack_exchange_user"

  get 'search', to: 'search#search_results'

  get "graphs", to: "graphs#index"

  get "status", to: "status#index"

  get "users", to: 'admin#users'

  get 'admin', to: 'admin#index'
  get 'admin/invalidated', to: 'admin#recently_invalidated'
  get 'admin/user_feedback', to: 'admin#user_feedback'
  get 'admin/api_feedback', to: 'admin#api_feedback'
  get 'admin/flagged', to: 'admin#flagged'
  post 'admin/clear_flag', to: 'admin#clear_flag'
  get 'admin/users', to: 'admin#users'
  get 'admin/ignored_users', to: 'admin#ignored_users'
  patch 'admin/ignore/:id', to: 'admin#ignore'
  patch 'admin/unignore/:id', to: 'admin#unignore'
  delete 'admin/destroy_ignored/:id', to: 'admin#destroy_ignored'

  get 'admin/new_key', to: 'admin#new_api_key'
  post 'admin/new_key', to: 'admin#create_api_key'
  get 'admin/keys', to: 'admin#key_list'

  get "posts", to: "posts#index"
  get "posts/latest", to: "posts#latest"
  get "posts/by-url", to: "posts#by_url"
  post 'posts/needs_admin', to: 'posts#needs_admin'
  get "post/:id/feedback/clear", to: "feedbacks#clear", as: :clear_post_feedback
  delete "feedback/:id/delete", to: "feedbacks#delete", as: :delete_feedback

  get "post/:id", to: "posts#show"
  get "post/:id/feedbacks.json", to: 'posts#feedbacksapi'

  get "/users", to: "stack_exchange_users#index"

  post 'feedbacks.json', to: "feedbacks#create"
  post 'posts.json', to: "posts#create"
  post 'deletion_logs.json', to: "deletion_logs#create"
  post "status-update.json", to: "status#status_update"

  get "dashboard", to: "dashboard#index"

  get "reason/:id", to: "reasons#show"

  get "posts/recent.json", to: "posts#recentpostsapi"
  post "posts/add_feedback", to: "review#add_feedback"

  get 'blacklist', to: 'blacklist#index'
  get 'blacklist/add_website', to: 'blacklist#add_website'
  post 'blacklist/add_website', to: 'blacklist#create_website'
  delete 'blacklist/website/:id', to: 'blacklist#deactivate_website'

  post 'github/hook'

  root to: "dashboard#index"

  get 'api/posts/url', :to => 'api#posts_by_url'
  get 'api/posts/feedback', :to => 'api#posts_by_feedback'
  get 'api/posts/:ids', :to => 'api#posts'
  get 'api/post/:id/feedback', :to => 'api#post_feedback'
  get 'api/post/:id/reasons', :to => 'api#post_reasons'
  get 'api/reasons/:ids', :to => 'api#reasons'
  get 'api/reasons/:id/posts', :to => 'api#reason_posts'

  post 'api/w/post/:id/feedback', :to => 'api#create_feedback'

  devise_for :users
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
