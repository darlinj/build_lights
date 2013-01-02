class UnableToGrabDataFromJenkins < RuntimeError

end

class JenkinsStatusGrabber
  def initialize grabber_library = Net::HTTP
    @grabber_library = grabber_library
    @uri = URI.parse(Configeration.jenkins_url)
  end
  
  def grab_status
    response = @grabber_library.get_response @uri
    raise UnableToGrabDataFromJenkins.new("Response code #{response.code}") unless response.code == "200"
    response.body
  end
end
