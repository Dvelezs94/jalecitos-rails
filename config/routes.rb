Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  root to: "pages#home"
  resources :admins, only: [] do
    collection do
      get :index_dashboard, as: 'dashboard'
      get :categories
      get :users
      get :disputes
      get :reports
      get :bans
      get :verifications
      get '/verifications/:id' => 'admins#show_verification', as: "show_verification"
      post :create_openpay_user
      post :charge_openpay_user
      get :openpay_dashboard
      get :tickets
      get :orders
      get :ally_codes
      post :predispersion_fee
      get :marketing_notifications
    end
  end
  #custom routes for city_id
  get '/jale/:city_slug/:id' => 'gigs#old_show', as: "old_gig"
  get '/jale/:city_slug/:category/:id' => 'gigs#show', as: "gig"
  get '/jale/:city_slug/:category/:id/edit' => 'gigs#edit', as: "edit_gig"
  patch '/jale/:city_slug/:category/:id' => 'gigs#update'
  put '/jale/:city_slug/:category/:id' => 'gigs#update'
  delete '/jale/:city_slug/:category/:id' => 'gigs#destroy'
  #doesnt need to be declared, just for spanish friendly url for user
  get '/jales/nuevo' => 'gigs#new', as: "new_gig"
  #post "/jales" => "gigs#create", as: "gigs" #doesnt need to be declared
  resources :marketing_notifications
  resources :gigs, except: [:index, :show, :edit, :update, :destroy, :new] do
    resource :reports, only: [:create], as: "report"
    member do
           get :toggle_status
           get :ban_gig, as: 'ban'
      end
    resource :like, only: [:create, :destroy]
  end

  resources :reviews, only: [:update, :create, :destroy]
  resources :ally_codes, only: [:create] do
    collection do
      post :trade
    end
  end

  resources :conversations, only: [:index, :create] do
    collection do
      get :check_unread
    end
    member do
      post :read_conversation, as: "read"
      post :close
    end
    resources :messages, only: [:create]
  end

   devise_for :users, path: '',controllers: {
     registrations: 'users/registrations',
     sessions: 'users/sessions',
     omniauth_callbacks: "users/omniauth_callbacks",
     confirmations: "users/confirmations",
     passwords: "users/passwords"
   }
   devise_scope :user do
     post 'user/disable', :to => 'users/registrations#disable'
   end
   resources :galleries, only: [:create, :destroy]
   resources :packages, except: [:destroy,:show,:index, :new, :edit, :update] do
     collection do
       patch 'update_packages', to: 'packages#update_packages', as: 'update'
     end
     member do
       get :hire
     end
   end
   resources :users, only: [:show] do
     collection do
       put :update_user, as: "update"
       get :my_account
       get :send_new_confirmation_email
     end
     resource :reports, only: [:create], as: "report"
     resources :banks, only: [:create, :destroy]
     resources :cards, only: [:create, :destroy]
     resources :billing_profiles, only: [:create, :destroy]
   end

   resources :requests, except: [:index] do
     resources :offers, except: [:index, :show] do
       member do
         get :hire
       end
     end
     resource :reports, only: [:create], as: "report"
   end

  resources :tickets do
    member do
      post :mark_as_resolved
    end
  end
  resources :ticket_responses
  resources :payouts, only: :create
  resources :notifications, only: [:index] do
    collection do
      post :mark_as_read
      get :all
    end
  end
  resources :categories
  resources :bans, only: [:create] do
    member do
      put :unban
    end
  end
  resources :orders, only: [:create] do
    member do
      put :refund
      put :request_complete
      put :complete
      put :request_start
      put :start
      put :pass_payment
      put :deny_payment
    end
    resources :disputes, only: [:new, :create, :show] do
      resources :replies, only: [:create]
    end
  end
  resources :order_webhooks, only: [] do
    collection do
      post :handle
    end
  end
  resources :verifications, only: [:new, :create] do
    member do
      put :approve
      put :deny
      put :cancel
    end
  end
  put "deny_report/:id", to: "reports#deny", as: "deny_report"
  get 'configuration', to: 'users#configuration'
  get 'wizard', to: 'pages#wizard'
  get 'finance', to: 'pages#finance'
  get 'disputes', to: 'disputes#index'
  get 'likes', to: 'pages#liked'
  # subscribe device to notifications
  post 'subscribe', to: 'notifications#subscribe'
  delete 'subscribe', to: 'notifications#drop_subscribe'
  # search routes
  # get 'guest_search', to: 'queries#guest_search'
  # get 'guest_autocomplete_search', to: 'queries#guest_autocomplete_search'

  # get 'user_autocomplete_search', to: 'queries#user_autocomplete_search'
  # get 'user_search', to: 'queries#user_search'

  get 'buscar', to: 'queries#search', as: "search"
  get '/guest_search', to: redirect { |path_params, req| "/buscar?#{req.params.to_query}" }
  get 'autocomplete_search', to: 'queries#autocomplete_search'


  get 'autocomplete_profession', to: 'queries#autocomplete_profession'
  get 'terminos-y-condiciones', to: 'pages#terms_and_conditions'
  get 'aviso-de-privacidad', to: 'pages#privacy_policy'
  get 'condiciones-de-venta', to: 'pages#sales_conditions'
  get '/robots.:format' => 'pages#robots'
  get '/sitemap', to: 'pages#sitemap'
  get '/gig_slugs', to: 'pages#gig_slugs'
  get '/install', to: 'pages#install'
  get 'reglas-prestador-empleador', to: 'pages#employer_employee_rules'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # LEAVE THIS AT THE END!!
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  match '*path' => redirect('/'), via: :get
end
