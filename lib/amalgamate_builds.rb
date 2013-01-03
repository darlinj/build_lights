require 'jenkins_status_grabber'
require 'build_data_munger'

class AmalgamateBuilds
  def status
    build_data = JenkinsStatusGrabber.new.grab_build_data
    BuildDataMunger.new(build_data).amalgamate
  end
end
