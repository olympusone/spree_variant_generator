Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    resources :products do
      member do
        get '/variant_generator_form', to: 'variant_generator#new'
        post '/variants_generate', to: 'variant_generator#create'
      end
    end
  end
end
