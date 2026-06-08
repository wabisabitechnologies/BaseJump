Rails.application.routes.draw do
  root 'sessions#new'

  get '/home', to: 'pages#home'

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  resources :projects do
    resources :todo_lists
    resources :messages
    resources :events
    resources :card_tables
  end

  resources :todo_lists do
    resources :todos do
      patch :toggle, on: :member
    end
  end

  resources :todos, only: [] do
    patch :toggle, on: :member
    resources :subtasks, only: [:create, :update, :destroy]
  end

  resources :messages, only: [] do
    resources :comments, only: [:create, :destroy]
  end

  resources :events, only: [] do
    resources :comments, only: [:create, :destroy]
  end

  resources :todo_lists, only: [] do
    resources :comments, only: [:create, :destroy]
  end
end