require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.warning = false
  test.test_files = Dir['test/**/test_*.rb']
end

task default: :test
