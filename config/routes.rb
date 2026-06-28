Rails.application.routes.draw do
  root 'sessions#new'

  get '/home', to: 'pages#home'
  resources :everything, only: [:index]
  get 'search', to: 'search#index', as: :search
  
  resources :templates, only: [:index], controller: 'project_templates'
  post 'templates/:id/create', to: 'project_templates#create', as: :create_template
  post 'templates/:id/use', to: 'project_templates#use_template', as: :use_template
  
  resources :tags, only: [:index, :create, :destroy]
  
  # Tagging routes
  post 'messages/:message_id/tags', to: 'tags#tag_item', as: :tag_message
  delete 'messages/:message_id/tags/:tag_id', to: 'tags#untag_item', as: :untag_message
  post 'todos/:todo_id/tags', to: 'tags#tag_item', as: :tag_todo
  delete 'todos/:todo_id/tags/:tag_id', to: 'tags#untag_item', as: :untag_todo
  post 'events/:event_id/tags', to: 'tags#tag_item', as: :tag_event
  delete 'events/:event_id/tags/:tag_id', to: 'tags#untag_item', as: :untag_event

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]


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

  resources :todos, only: [:create] do
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

  resources :comments, only: [:destroy]

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
  # React SPA remains addressable for unported features (calendar, kanban, etc.)
  get '/app', to: 'react_app#index'
  get '/app/*path', to: 'react_app#index'
end