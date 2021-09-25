Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    resources :products do
      member do
        get '/variant_generator_form', to: 'variant_generator#new'
      end
    end
  end
end
