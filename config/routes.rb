Rails.application.routes.draw do
  resources :bets
  resources :tournaments

  get 'teams', to: 'teams#index'
  get 'teams/:id', to: 'teams#show'

  get 'tournaments', to: 'tournaments#index'
  get 'tournaments/:id', to: 'tournaments#show'
  get 'tournaments/:id/teams', to: 'tournaments#teams'
  get 'tournaments/:id/stages', to: 'tournaments#stages'
  get 'tournaments/:id/stages/:stage_id', to: 'tournaments#stage'

  get 'matches', to: 'matches#index'
  get 'matches/:id', to: 'matches#show'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
