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
     confirmations: "users/confirmations"
   }
   resources :users, only: [:show, :update] do
     resource :reports, only: [:create], as: "report"
     get 'configuration', to: 'users#configuration', as: 'config'
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
     collection do
       get :my_requests, as: "my"
     end
     resource :reports, only: [:create], as: "report"
   end

  resources :withdrawals, only: :create
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
    end
    resources :disputes, only: [:index, :new, :create, :show] do
      resources :replies, only: [:create]
    end
  end
  resources :verifications, only: [:new, :create] do
    member do
      put :approve
      put :deny
    end
  end
  get 'requests', to: 'pages#request_index'
  get 'finance', to: 'pages#finance'
  get 'disputes', to: 'disputes#index'
  get 'likes', to: 'pages#liked'
  get 'autocomplete', to: 'pages#autocomplete'
  # subscribe device to notifications
  post 'subscribe', to: 'notifications#subscribe'
  delete 'subscribe', to: 'notifications#drop_subscribe'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
