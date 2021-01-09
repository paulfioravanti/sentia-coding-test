class DataImportController < ApplicationController
  def create
    DataImporter.import(params[:file])
    redirect_to root_url, flash: { success: "Data imported successfully!" }
  rescue => error
    redirect_to root_url, flash: { error: error.message }
  end
end
