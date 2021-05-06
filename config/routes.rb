Rails.application.routes.draw do
  resource :data_import, only: %i[create destroy]
  root "people#index"
end
