# frozen_string_literal: true

class DataImportsController < ApplicationController
  def create
    DataImporter.import(params[:file])
    redirect_to root_url,
                flash: { success: "Data imported successfully!" }
  rescue StandardError
    redirect_to root_url,
                flash: { error: "There were errors importing the data." }
  end

  def destroy
    ActiveRecord::Tasks::DatabaseTasks.truncate_all
    redirect_to root_url, flash: { success: "Data deleted successfully!" }
  end
end
