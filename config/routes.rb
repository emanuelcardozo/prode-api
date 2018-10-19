Rails.application.routes.draw do
  resources :bets
  resources :tournaments

  get 'teams', to: 'teams#index'
  get 'teams/:id', to: 'teams#show'

  get 'tournaments', to: 'tournaments#index'
  get 'tournaments/:id', to: 'tournaments#show'
  get 'tournaments/:id/teams', to: 'tournaments#teams'
  get 'tournaments/:id/stages', to: 'tournaments#stages'
  get 'tournaments/:id/stages/:stage_number', to: 'tournaments#stage'
  get 'tournaments/:id/states', to: 'tournaments#states'

  get 'matches', to: 'matches#index'
  get 'matches/:id', to: 'matches#show'

  get 'tournaments/:id/points', to: 'points#tournament_points'
  get 'tournaments/:id/stages/:stage_number/points', to: 'points#stage_points'

  get '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
