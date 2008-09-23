ActionController::Routing::Routes.draw do |map|
  map.resources :entry_systems, :has_many => [:images, :pdf_manuals]

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
