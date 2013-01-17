require "rake/clean"

CLEAN.include %w(log/** tmp/** coverage coverage.data)

Rake.application.instance_variable_get('@tasks').delete('default')

task :default => [:clean, :"code:all", :spec, :'cucumber', :'cucumber:wip', :ok]

task :ok do
  red    = "\e[31m"
  yellow = "\e[33m"
  green  = "\e[32m"
  blue   = "\e[34m"
  purple = "\e[35m"
  bold   = "\e[1m"
  normal = "\e[0m"
  puts "", "#{bold}#{red}*#{yellow}*#{green}*#{blue}*#{purple}* #{green} ALL TESTS PASSED #{purple}*#{blue}*#{green}*#{yellow}*#{red}*#{normal}"
end
