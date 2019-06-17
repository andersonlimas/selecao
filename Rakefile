require "rake/testtask"

# Load all rake tasks inside the tasks folder
dir = File.join(File.dirname(__FILE__), 'tasks')
glob = Dir.glob(dir + "/**/*.rake")
glob.each { |r| load r }


Rake::TestTask.new(:run_tests) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/app/**/*.rb"]
end

task :default => :run_tests
