Rails.application.routes.draw do
  get 'admins/dashboard'

  resources :conversations do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end

   devise_for :users, controllers: {
     sessions: 'users/sessions'
   }
   resources :users do
     resources :gigs do
         member do
              get :toggle_status
              get :ban_gig, as: 'ban'
         end
         resources :packages, except: [:destroy,:show,:index, :edit, :update] do
           collection do
             get 'edit_packages', to: 'packages#edit_packages', as: 'edit'
             patch 'update_packages', to: 'packages#update_packages', as: 'update'
           end
         end
     end

     resources :requests, except: :index do
       resources :offers, except: [:index, :show]
         collection do
           get 'my_requests', as: 'my'
       end
     end
     resources :categories
   end
  get 'requests', to: 'pages#requests_index'
  root to: "pages#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
