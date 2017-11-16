require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Regenerate interpreter file from definitions"
task "interpreter:generate" do
  puts `bundle exec racc -o #{__dir__}/lib/search_query_parser/interpreter.rb #{__dir__}/lib/search_query_parser/interpreter.y`
end
