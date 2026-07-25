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
    resources :visits, only: [ :create, :destroy ]
    resources :quotes, only: [ :create ]
    resources :checklist_items, only: [ :create, :update, :destroy ]
    resources :job_checklists, only: [ :create ]
    resources :time_entries, only: [ :create ]
  end

  resources :time_entries, only: [ :create, :update ]
  resources :checklist_templates, except: [ :show ]

  get "dnesek", to: "today#show", as: :today

  # Správa týmu je pod /tym, protože /users si drží Devise pro registraci.
  get "tym/export", to: "team_hours_exports#show", as: :team_hours_export
  resources :users, path: "tym", except: [ :show ]

  get "kalendar", to: "calendar#show", as: :calendar
  resources :visits, only: [ :index, :update ]

  resources :services

  resources :inquiries, only: [ :index ]

  # Veřejný poptávkový formulář firmy — bez přihlášení, adresa podle slugu.
  get "poptavka/:account_slug", to: "public/job_requests#new", as: :public_job_request
  post "poptavka/:account_slug", to: "public/job_requests#create", as: :public_job_requests
  get "poptavka/:account_slug/odeslano", to: "public/job_requests#sent", as: :public_job_request_sent

  # Client hub — zákazníkova stránka jedné zakázky. V adrese je jen náhodný token.
  get "z/:token", to: "public/client_hub#show", as: :client_hub
  post "z/:token/nabidka", to: "public/quote_decisions#create", as: :client_hub_quote_decision

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
