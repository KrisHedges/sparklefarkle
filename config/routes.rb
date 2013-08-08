Sparklefarkle::Application.routes.draw do
  resources :highscores do
    collection {post :sort}
  end
  root :to => 'game#index'
end
