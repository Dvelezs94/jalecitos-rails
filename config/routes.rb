Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  root to: "pages#home"
  get 'admins/dashboard'

  resources :conversations do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end

   devise_for :users, path: '',controllers: {
     registrations: 'users/registrations',
     sessions: 'users/sessions',
     omniauth_callbacks: "users/omniauth_callbacks",
     confirmations: "users/confirmations"
   }
   resources :users, only: [:show, :edit, :update] do
     get 'configuration', to: 'users#configuration', as: 'config'
     resources :banks, only: [:create, :destroy]
     resources :cards, only: [:create, :destroy]
     resources :gigs, except: :index do
         member do
              get :toggle_status
              get :ban_gig, as: 'ban'
         end
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
     resources :offers, except: [:index, :show]
   end

  resources :withdrawals, only: :create
  resources :notifications
  resources :categories
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
  get 'requests', to: 'pages#request_index'
  get 'finance', to: 'pages#finance'
  get 'disputes', to: 'disputes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
