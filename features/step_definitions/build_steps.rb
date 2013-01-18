require_relative '../../lib/amalgamate_builds'

Given /^all the builds are green$/ do
  AmalgamateBuilds::Configuration.jenkins_url = "http://www.example.com/"
  data_file = File.open("#{File.dirname(__FILE__)}/../rss_feed_with_no_failed_builds")
  jenkins_data = data_file.read
  data_file.close
  stub_request(:get, "www.example.com").to_return(:body => jenkins_data)
end

Then /^I should see the amalgamated response is green$/ do
  AmalgamateBuilds::Amalgamate.new.status.should == "green"
end

When /^there are some failed builds$/ do
  AmalgamateBuilds::Configuration.jenkins_url = "http://www.example.com/"
  data_file = File.open("#{File.dirname(__FILE__)}/../rss_feed_with_failed_builds")
  jenkins_data = data_file.read
  data_file.close
  stub_request(:get, "www.example.com").to_return(:body => jenkins_data)
end

Then /^I should see the amalgamated response is red$/ do
  AmalgamateBuilds::Amalgamate.new.status.should == "red"
end
