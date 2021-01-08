class DataImportController < ApplicationController
  def create
    DataImporter.import(params[:file])
    redirect_to root_url, notice: "Data imported successfully!"
  rescue => error
    redirect_to root_url, error: error.message
  end
end
