Rails.application.routes.draw do
  root "dashboard#index"

  resources :clients, except: :show
  resources :invoices do
    member do
      patch :mark_as_sent
      patch :mark_as_paid
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
