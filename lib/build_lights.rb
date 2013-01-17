require "sinatra/base"
require "sinatra/config_file"
require_relative "configuration"
require_relative "amalgamate_builds"

class BuildLights < Sinatra::Base
  register Sinatra::ConfigFile
  config_file "../config/config.yml"

  get "/" do
    begin
      AmalgamateBuilds::Amalgamate.new.status
    rescue UnableToGrabDataFromJenkins
      "Unknown"
    end
  end

  configure do
    AmalgamateBuilds::Configuration.jenkins_url = settings.jenkins_url
  end
end
