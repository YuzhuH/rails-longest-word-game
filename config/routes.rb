Rails.application.routes.draw do

  get '/play', to: "games#play"
  post '/scores', to: "games#scores"
  get '/', to: "games#play"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
