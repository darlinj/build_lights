class AmalgamateBuilds
  def status
    JenkinsStatusGrabber.new.grab_build_data
  end
end
