Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
  }

  root 'homes#top'
  get '/about' => 'homes#about'
  get '/search' => 'search#search'

  resources :users, only: [:show, :edit, :update, :index, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :posts do
    resource :likes, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  resources :tags, except: [:index, :create, :new, :edit, :show, :update, :destroy] do
    get 'posts' => 'posts#tagsearch'
  end

  resources :chats, only: [:show, :create]
end
