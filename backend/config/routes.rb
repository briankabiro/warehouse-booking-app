Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  namespace :api do
    namespace :v1 do
      resources :slots, only: [:index, :create] do
        collection do
          post '/search', to: 'slots#search'
          post '/booked_slots', to: 'slots#booked_slots'
        end
      end
    end
  end  
end
