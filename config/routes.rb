Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  post '/order' => 'orders#create', :as => 'order'
  root to: "pages#home"
  get 'admins/dashboard'

  resources :conversations do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end

   devise_for :users, controllers: {
     registrations: 'users/registrations',
     sessions: 'users/sessions',
     omniauth_callbacks: "users/omniauth_callbacks"
   }
   resources :users, only: [:show, :edit, :update] do
     get 'configuration', to: 'users#configuration', as: 'config'
     resources :banks, only: [:create, :destroy]
     resources :cards, only: [:create, :destroy]
   end

   resources :requests, except: :index do
     resources :offers, except: [:index, :show]
   end

   resources :users do
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
  resources :notifications
  resources :categories
  get 'requests', to: 'pages#requests_index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
