module AmalgamateBuilds
  module Configuration
    extend self
    attr_accessor :jenkins_url
    attr_accessor :proxy_url
    attr_accessor :proxy_port
  end
end
