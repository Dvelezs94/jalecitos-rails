Rails.application.routes.draw do
  resources :gigs do
      member do
           get :toggle_status
           get :ban_gig, as: 'ban'
      end
  end
  resources :conversations do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end
  resources :categories
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root to: "pages#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
