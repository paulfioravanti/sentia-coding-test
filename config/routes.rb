Rails.application.routes.draw do
  resource :data_import, only: [:create, :destroy]
  root "people#index"
end
