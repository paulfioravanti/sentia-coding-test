Rails.application.routes.draw do
  post 'data_import/create' => 'data_import#create'
  root 'people#index'
end
