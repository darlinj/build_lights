require_relative 'jenkins_status_grabber'
require_relative 'build_data_munger'

module AmalgamateBuilds
  class Amalgamate
    def status
      build_data = JenkinsStatusGrabber.new.grab_build_data
      BuildDataMunger.new(build_data).amalgamate
    end
  end
end
