namespace :db do
  task init: :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    ENV["FIXTURES"] = "locations,affiliations"
    Rake::Task["db:fixtures:load"].invoke
  end
end
