Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :lsm do
    namespace :api do
      namespace :v1 do
        resources :courses, only: [:index, :show, :create, :update, :destroy]
        resources :lessons, only: [:index, :show, :create, :update, :destroy]
        post "courses/:course_id/lessons/:id/start",    to: "lessons_progress#start"
        post "courses/:course_id/lessons/:id/complete", to: "lessons_progress#complete"
      end
    end
  end  
end
