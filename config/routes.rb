Rails.application.routes.draw do
  resources :bets
  resources :tournaments

  get 'teams', to: 'teams#index'
  get 'teams/:id', to: 'teams#show'

  get 'sign_in', to: 'users#register'

  get 'main_match', to: 'main_matches#index'

  get 'tournaments', to: 'tournaments#index'
  get 'tournaments/:id', to: 'tournaments#show'
  get 'tournaments/:id/teams', to: 'tournaments#teams'
  get 'tournaments/:id/stages', to: 'tournaments#stages'
  get 'tournaments/:id/stages/:stage_number', to: 'tournaments#stage'
  get 'tournaments/:id/states', to: 'tournaments#states'

  get 'matches', to: 'matches#index'
  get 'matches/:id', to: 'matches#show'

  get 'match/:id/points', to: 'points#main_match_points'
  get 'tournaments/:id/points', to: 'points#tournament_points'
  get 'tournaments/:id/stages/:stage_number/points', to: 'points#stage_points'

  get 'bets_of_match', to: 'bets#bets_of_match'

  post 'alias', to: 'users#change_alias'
  post 'bet_matches', to: 'bet_matches#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
