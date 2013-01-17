require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end
