require "sinatra/base"
require_relative "configuration"
require_relative "amalgamate_builds"

class BuildLights < Sinatra::Base
  get "/" do
    begin
      AmalgamateBuilds::Amalgamate.new.status
    rescue UnableToGrabDataFromJenkins
      "Unknown"
    end
  end

  configure do
    AmalgamateBuilds::Configuration.jenkins_url = "http://ci.nat.bt.com/rssLatest"
  end
end
