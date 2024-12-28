# frozen_string_literal: true

class WWWSubdomainConstraint
  def self.matches?(request)
    request.subdomain == "www"
  end
end

Rails.application.routes.draw do
  constraints(WWWSubdomainConstraint) do
    match "(*any)" => redirect { |_params, request|
      URI.parse(request.url).tap { |uri| uri.host.sub!(/^www\./i, "") }.to_s
    }, via: [:get, :post, :put, :patch, :delete]
  end

  constraints subdomain: [""] do
    resources :sign_ups, only: [:create, :edit, :update], param: :alt_id
    resources :articles, only: [:index, :show], param: :slug, module: :marketing

    namespace :marketing do
      resources :email_subscribes, only: :create
      resources :purchases, only: [:create, :show], param: :alt_id
    end
  end

  constraints subdomain: "app" do
    get "/", to: "home#index", as: :home

    # auth
    get "/login", to: "authentication#login"
    post "/login", to: "authentication#validate"
    get "/logout", to: "authentication#logout"

    post "/stripe", to: "stripe#webhook"

    resources :tokens, only: %i[show update], param: :alt_id
    resources :schedules
    resources :password_resets, only: %i[new create]
    resource :me, only: :update, controller: :me

    resources :accounts do
      resource :primary_note, only: [:update], controller: :primary_note, module: :accounts

      # settings controllers
      resource :billing, only: :show, module: :accounts, controller: :billing
      resources :subaccounts, only: [:index], module: :accounts

      resource :settings, only: :show, module: :accounts do
        resource :logo, only: %i[edit update], module: :settings, controller: :logo
      end

      resources :members, only: %i[index new create edit destroy], module: :accounts do
        resource :roles, only: %i[edit update], module: :members
      end

      member do
        patch "/update_link_redirects", action: :update_link_redirects
      end
    end

    namespace :organization do
      resource :settings, only: %i[show update]
      resources :integrations, only: %i[index new create edit update]
      resources :subaccounts, only: %i[index new update create]

      resource :billing, only: :show, controller: :billing do
        resources :sub_account_purchases, only: %i[new create], module: :billing
      end

      resources :users, only: %i[index new create edit update destroy] do
        resources :account_members,
          only: %i[new create edit update destroy],
          module: :users
      end
    end

    #
    # billing
    #

    # TODO: sign ups here

    #
    # settings
    #

    namespace :settings do
      root to: "profile#show"

      resource :profile, controller: :profile, only: :show

      resource :account, controller: :account, only: :show do
        member do
          resources :user_additions,
            only: %i[new create],
            module: :account
        end
      end

      resources :sub_accounts, only: :index
    end

    resources :messages, only: [:create, :new, :destroy]

    #
    # external routes
    #

    resources :o,
      only: %i[show update],
      as: :external_organization,
      module: :external,
      controller: :organizations do
      resources :sign_ups, only: [:new, :create]
    end

    resources :n,
      only: [:show],
      as: :external_notes,
      controller: :notes,
      module: :external,
      param: :alt_id do
    end

    resources :a,
      only: [:show],
      as: :external_accounts,
      controller: :accounts,
      module: :external,
      param: :alt_id

    namespace :external do
      resource :authentication, only: :create, controller: :authentication
      resource :me, only: [:show, :update, :edit], controller: :me

      resources :note_instances, only: [] do
        resources :fill_in_values, only: :update, param: :index, module: :note_instances
      end

      resources :notes, only: [:show], param: :alt_id do
        resources :emails, module: :notes, only: %i[new create]
        resources :downloads, module: :notes, only: :new
      end
    end

    #
    # notes
    #

    resources :notes, param: :alt_id do
      collection do
        get :search
      end

      resource :banner, module: :notes
      resource :analytics, only: :show, module: :notes, controller: :analytics
      resources :actions, except: :show, module: :notes
    end

    #
    # staff routes
    #

    resource :staff, only: [:show], controller: :staff

    namespace :staff do
      resources :organizations
    end
  end
end
