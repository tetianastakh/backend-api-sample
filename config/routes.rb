Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get 'healthcheck/status', controller: 'healthcheck#status'
  root to: 'healthcheck#status'

  namespace :accounts do
    namespace :api do
      namespace :v1 do
        resources :users
        resources :roles
        resources :permissions, only: [:index]
      end
    end
  end
end
