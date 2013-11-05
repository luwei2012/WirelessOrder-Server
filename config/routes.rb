# -*- encoding : utf-8 -*-
WirelessOrder::Application.routes.draw do
  resources :dish_styles

  resources :dish_types

  resources :menus

  resources :dishes do
    get 'select_type', on: :collection
    get 'select_style', on: :collection
    post 'image_upload', on: :collection
  end

  get 'authorities/index'
  #get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :welcome
  resources :authorities do
    get 'logout', on: :collection
  end
  resources :tables do
    get 'select_type', on: :collection
  end
  #移动端
  namespace :mobile do
    resources :login do
      post 'sign', on: :collection
    end

    resources :m_dish do
      get 'dish_type_list', on: :collection
      get 'dish_style_list', on: :collection
    end

    resources :m_table do
      get 'dish_list', on: :collection
      get 'order', on: :collection
      get 'check_out', on: :collection
      get 'add_dish', on: :collection
      get 'remove_dish', on: :collection
      get 'verify_menu', on: :collection
    end
  end
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
