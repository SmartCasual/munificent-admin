module Munificent
  module Admin
    Engine.routes.draw do
      # Non-resource stuff
      resource :dashboard

      # Resources
      resources :bundles do
        StateMachineHelper.define_routes(self, Bundle)
      end
      resources :bundle_tiers, only: [:destroy]
      resources :charities
      resources :donations
      resources :donator_bundles
      resources :donators
      resources :fundraisers do
        StateMachineHelper.define_routes(self, Fundraiser)
      end
      resources :games do
        member do
          get "csv_upload"
          post "upload_csv"
        end
      end
      resources :users

      # Authentication
      resource :user_session, only: [:create, :destroy]

      get "/login" => "user_sessions#new", as: :new_user_session

      get "/2sv/setup", to: "otp#setup", as: "otp_setup"
      get "/2sv/verify", to: "otp#input", as: "otp_input"
      post "/2sv/verify", to: "otp#verify", as: "otp_verify"

      # Root
      root to: "dashboard#index"
    end
  end
end
