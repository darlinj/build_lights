require_relative "configuration"
require 'net/http'

class UnableToGrabDataFromJenkins < RuntimeError

end

class JenkinsStatusGrabber
  def grab_build_data url
    @uri = URI.parse(url)
    response = Net::HTTP.get_response @uri
    raise UnableToGrabDataFromJenkins.new("Response code #{response.code}") unless response.code == "200"
    response.body
  rescue Timeout::Error
    raise UnableToGrabDataFromJenkins.new("Request timed out")
  end
end
