class JenkinsStatusGrabber
  def initialize grabber_library = Net::HTTP
    @grabber_library = grabber_library
  end
  
  def grab_status
    @grabber_library.get_response Configeration.jenkins_url
  end
end
