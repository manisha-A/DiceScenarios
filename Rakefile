require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:local_tests) do |t|
  t.profile = "local"
end

Cucumber::Rake::Task.new(:ci_tests) do |t|
  t.profile = "ci"
end