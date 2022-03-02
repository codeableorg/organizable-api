Rails.application.routes.draw do
  resources :users, except: [:index]

  resources :boards do
    resources :lists, only: %i[create update destroy] do
      post :sort, on: :collection
    end
    resources :labels, only: %i[create update destroy]
  end
  
  resources :lists, only: [] do
    resources :cards, except: [:index] do
      post :sort, on: :collection
    end
  end

  resources :cards, only: [] do
    resources :checklists, only: %i[create update destroy]
  end

  resources :checklists, only: [] do
    resources :check_items, only: %i[create update destroy]
  end

  post 'cards/:card_id/cards_labels', to: 'cards_labels#create'
  delete 'cards/:card_id/cards_labels', to: 'cards_labels#destroy'

  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'
end
