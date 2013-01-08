require_relative '../../lib/amalgamate_builds'
require 'debugger'

Given /^all the builds are green$/ do
  Configuration.config do
    parameter :jenkins_url
  end
  Configuration.jenkins_url = "http://www.example.com"
  stub_request(:get, "www.example.com").to_return(:body => "<xml>some data</xml>")
end

When /^I request the build status$/ do
  AmalgamateBuilds.new.status.should == "Green"
end
