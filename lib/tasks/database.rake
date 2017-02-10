namespace :db do
  desc 'Additional migrate task that creates the diagram'
  task :migrate do
    `rails db:migrate RAILS_ENV=test`
  end
end