Sparklefarkle::Application.routes.draw do
  resources :highscores
  root :to => 'game#index'
end
