Rails.application.routes.draw do

  root 'authorities#index'

  resources :authorities

end
