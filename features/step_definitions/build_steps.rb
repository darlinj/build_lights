require_relative '../../lib/amalgamate_builds'
require 'debugger'

Given /^all the builds are green$/ do
  Configuration.config do
    parameter :jenkins_url
  end
  Configuration.jenkins_url = "http://www.example.com"
  data_file = File.open("#{File.dirname(__FILE__)}/../rss_feed_with_no_failed_builds")
  jenkins_data = data_file.read
  data_file.close
  stub_request(:get, "www.example.com").to_return(:body => jenkins_data)
end

Then /^I should see the amalgamated response is green$/ do
  AmalgamateBuilds.new.status.should == "green"
end

When /^there are some failed builds$/ do
  Configuration.jenkins_url = "http://www.example.com"
  data_file = File.open("#{File.dirname(__FILE__)}/../rss_feed_with_failed_builds")
  jenkins_data = data_file.read
  data_file.close
  stub_request(:get, "www.example.com").to_return(:body => jenkins_data)
end

Then /^I should see the amalgamated response is red$/ do
  AmalgamateBuilds.new.status.should == "red"
end

