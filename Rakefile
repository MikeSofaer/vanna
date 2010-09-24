task :default => :test

desc 'run all tests (in current ruby)'
task :test do
  sh "bundle exec ruby test/basic_test.rb"
  sh "bundle exec ruby test/personas_test.rb"
end
