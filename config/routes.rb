ActionController::Routing::Routes.draw do |map|
  
  map.resources :event_dates, :member => {:rate => :post}
  
  map.rate_event_dates '/event_dates/:id/rate', :controller => 'event_dates', :action => 'rate'
  
  map.resources :locations, :has_many => [:reviews, :criteria, :events]
  map.resources :events
  
  map.resources :event_types
  map.resources :event_dates
  map.resources :criterias
  
  map.resources :posts
  map.blog      '/blog', :controller => 'posts'

  
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.forgot    '/forgot', :controller => 'users', :action => 'forgot'  
  map.reset     'reset/:reset_code', :controller => 'users', :action => 'reset'
  
  map.resources :users, :member => {:rate => :post}, :collection => {:link_user_accounts => :get}
   
  map.resource :session
  
  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.assign_criteria 'locations/:id/criterias', :controller => 'criterias', :action => 'edit_location'
  map.rate_criteria 'locations/:id/rate_criterias', :controller => 'criterias', :action => 'rate_location'
  
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "events"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
    
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
