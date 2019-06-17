require './app/use_cases/organize_conference'

desc 'Organize a Conference'
task :organize_lectures, :proposals_path do |_, args|
  puts ::UseCases::OrganizeConference.new(args[:proposals_path]).call
end
