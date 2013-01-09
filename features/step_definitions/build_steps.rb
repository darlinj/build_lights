require_relative '../../lib/amalgamate_builds'
require 'debugger'

Given /^all the builds are green$/ do
  Configuration.config do
    parameter :jenkins_url
  end
  Configuration.jenkins_url = "http://www.example.com"
  jenkins_data = %q{
    <xml>
      <build>
        <status>
          This build is Green
        </status>
      </build>
      <build>
        <status>
          Green stuff
        </status>
      </build>
    </xml>}
  stub_request(:get, "www.example.com").to_return(:body => jenkins_data)
end

Then /^I should see the amalgamated response is green$/ do
  AmalgamateBuilds.new.status.should == "green"
end
