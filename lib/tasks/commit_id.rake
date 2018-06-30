require 'net/http'

namespace :commit_id do
  desc 'save commit_id from git_log to DB'
  task :save_to_db => :environment do
    begin
      Task.all.where(commit_id: nil).each do |task|
        path = task.pages.first.text_file_name if task.pages

        task.commit_id = GitDb.new.latest_commit(path) if path
        task.save
      end
    rescue StandardError => exc
      logger.error("Message for the log file #{exc.message}")
      puts 'Probably no such path in git log'
    end
  end

  desc 'remove all commit_id from DB'
  task :remove_from_db => :environment do
    Task.all.where.not(commit_id: nil).each do |task|
      task.commit_id = nil
      task.save
    end
  end
end
