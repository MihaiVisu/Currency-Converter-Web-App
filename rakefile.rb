
#creating the rakefile for running the tests

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "tests"
  
  # generating the list of test files, in case there will be more than 1
  t.test_files = FileList['tests/test*.rb']
  t.verbose = true
end