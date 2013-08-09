Sparklefarkle::Application.routes.draw do
  get '/highscores', :to => 'highscores#index'
  post '/highscores', :to => 'highscores#create'
  root :to => 'game#index'
end
