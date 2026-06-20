Rails.application.routes.draw do
  root 'react_app#index'

  get '/home', to: 'react_app#index'

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

  # JSON API routes for React frontend
  namespace :api do
    resource :session, only: [:create, :destroy]
    resources :users, only: [:create, :show] do
      resources :projects, only: [:index]
    end
    resources :projects, only: [:index, :show, :create, :update] do
      resources :todos, only: [:index]
      resources :todolists, only: [:index]
      resources :messages, only: [:index]
      resources :events, only: [:index]
    end
    resources :todolists, only: [:show, :create, :update] do
      resources :todos, only: [:index]
      resources :comments, only: [:index]
    end
    resources :todos, only: [:show, :create, :update] do
      patch :toggle, on: :member
    end
    resources :messages, only: [:show, :create, :update, :destroy] do
      resources :comments, only: [:index]
    end
    resources :events, only: [:show, :create, :update, :destroy] do
      resources :comments, only: [:index]
    end
    resources :comments, only: [:create, :update, :destroy]
    resources :companies, only: [:show, :update]

    # Loose todos & subtasks (Phase 1 features)
    get '/projects/:project_id/loose_todos', to: 'todos#index', defaults: { loose: true }
    resources :subtasks, only: [:create, :update, :destroy]
  end
  # Catch-all: serve React SPA for unrecognized routes (must be last)
  get '*path', to: 'react_app#index'
end