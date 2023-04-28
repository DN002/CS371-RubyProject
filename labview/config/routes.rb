Rails.application.routes.draw do
  resources :entries
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Redefining root route as the view_all action:
  root 'entries#view_all'

  # Defining this route to use new view_all controller action:
  get '/entries/view_all' => 'entries#view_all'

end
