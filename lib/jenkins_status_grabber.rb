require_relative "configuration"
class UnableToGrabDataFromJenkins < RuntimeError

end

class JenkinsStatusGrabber
  def initialize grabber_library = Net::HTTP
    @grabber_library = grabber_library
    @uri = URI.parse(Configuration.jenkins_url)
  end
  
  def grab_build_data
    response = @grabber_library.get_response @uri
    raise UnableToGrabDataFromJenkins.new("Response code #{response.code}") unless response.code == "200"
    response.body
  rescue SocketError
    raise UnableToGrabDataFromJenkins.new("Socket error - Possibly a problem with the configured uri for Jenkins")
  end
end
