Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  root to: "pages#home"
  resources :admins, only: [] do
    collection do
      get :index_dashboard, as: 'dashboard'
      get :categories
      get :users
      get :disputes
      get :bans
      get :verifications
      post :create_openpay_user
      get :openpay_dashboard
      get :tickets
    end
  end

  resources :reviews, only: [:update]

  resources :conversations do
    member do
      post :close
      post :mark_as_read
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
   resources :users, only: [:show] do
     collection do
       put :update_user, as: "update"
       get :my_account
     end
     resource :reports, only: [:create], as: "report"
     resources :banks, only: [:create, :destroy]
     resources :cards, only: [:create, :destroy]
     resources :billing_profiles, only: [:create, :destroy]

     resources :gigs, except: :index do
       resource :reports, only: [:create], as: "report"
       resources :galleries, only: [:index, :create, :destroy]
       member do
              get :toggle_status
              get :ban_gig, as: 'ban'
         end
         resource :like, only: [:create, :destroy]
         resources :packages, except: [:destroy,:show,:index, :edit, :update] do
           collection do

             get 'edit_packages', to: 'packages#edit_packages', as: 'edit'
             patch 'update_packages', to: 'packages#update_packages', as: 'update'
           end
           member do
             get :hire
           end
         end
     end
   end

   resources :requests, except: :index do
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
  resources :bans, only: [] do
    member do
      put :proceed
      put :deny
    end
  end
  resources :orders, only: [:create] do
    member do
      put :refund
      put :request_complete
      put :complete
      put :request_start
      put :start
      get :details
      put :update_details
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
    end
  end
  get 'mobile_sign_in', to: 'mobiles#sign_in'
  get 'mobile_sign_up', to: 'mobiles#sign_up'
  get 'configuration', to: 'users#configuration'
  get 'requests', to: 'pages#request_index'
  get 'finance', to: 'pages#finance'
  get 'disputes', to: 'disputes#index'
  get 'likes', to: 'pages#liked'
  # subscribe device to notifications
  post 'subscribe', to: 'notifications#subscribe'
  delete 'subscribe', to: 'notifications#drop_subscribe'
  # search routes
  get 'guest_search', to: 'queries#guest_search'
  get 'guest_autocomplete_search', to: 'queries#guest_autocomplete_search'

  get 'user_mobile_search', to: 'queries#user_mobile_search'
  get 'user_search', to: 'queries#user_search'
  get 'user_autocomplete_search', to: 'queries#user_autocomplete_search'
  get 'autocomplete_profession', to: 'queries#autocomplete_profession'
  get 'autocomplete_location', to: 'queries#autocomplete_location'
  get 'terminos-y-condiciones', to: 'pages#terms_and_conditions'
  get 'aviso-de-privacidad', to: 'pages#privacy_policy'
  get 'condiciones-de-venta', to: 'pages#sales_conditions'
  get 'reglas-prestador-empleador', to: 'pages#employer_employee_rules'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # LEAVE THIS AT THE END!!
  match '*path' => redirect('/'), via: :get
end
