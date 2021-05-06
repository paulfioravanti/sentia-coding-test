# frozen_string_literal: true

namespace :db do
  task init: :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:fixtures:load"].invoke
  end
end
