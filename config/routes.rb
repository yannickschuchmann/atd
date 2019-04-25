require 'sidekiq/web'

Rails.application.routes.draw do
  root 'react#index'

  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/sidekiq'
end
