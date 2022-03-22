Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Tokens from doorkeeper

  # {host}/v1/{controller}
  namespace :api, path: "" do
    namespace :v1 do
      # Clinics
      resources :clinics, only: [:index, :create, :update]
      get 'agendas_services', to: 'agendas#agendas_services'
    end
  end
end
