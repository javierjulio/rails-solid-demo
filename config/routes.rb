Rails.application.routes.draw do
  root "rooms#show", defaults: { id: :lobby }

  resources :rooms, only: :show do
    resources :messages, only: :create
    resource :stats, only: :show, controller: :room_stats
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
