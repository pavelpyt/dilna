Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root "dashboard#show"

  resources :clients do
    resources :properties, only: [ :new, :create, :edit, :update, :destroy ]
    resources :contacts, only: [ :new, :create, :edit, :update, :destroy ]
  end

  resources :jobs do
    resource :status, only: [ :update ], controller: "job_statuses"
    resources :job_items, only: [ :create, :destroy ]
    resources :notes, only: [ :create, :destroy ]
    resources :job_photos, only: [ :create, :destroy ]
  end

  resources :services

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
