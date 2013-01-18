require_relative "configuration"
require 'net/http'

class UnableToGrabDataFromJenkins < RuntimeError

end

class JenkinsStatusGrabber
  def initialize
    @proxy = AmalgamateBuilds::Configuration.proxy_url
    @port = AmalgamateBuilds::Configuration.proxy_port
  end

  def grab_build_data
    u = URI.parse(AmalgamateBuilds::Configuration.jenkins_url)
    proxy_class = Net::HTTP::Proxy(@proxy, @port)
    proxy_class.start(u.host) do |h|
      req = Net::HTTP::Get.new(u.path);
      r = h.request( req );
      raise UnableToGrabDataFromJenkins.new("Response code #{r.code}") unless r.code == "200"
      r.body
    end
  rescue Timeout::Error
    raise UnableToGrabDataFromJenkins.new("Request timed out")
  end
end
