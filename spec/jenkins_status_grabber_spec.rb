require "jenkins_status_grabber"
require 'webmock/rspec'

describe JenkinsStatusGrabber, "grab_build_data" do
  before do
    AmalgamateBuilds::Configuration.jenkins_url = "http://www.example.com/build_data"
    AmalgamateBuilds::Configuration.proxy_url   = "http://proxy.example.com"
    AmalgamateBuilds::Configuration.proxy_port  = 8080
  end

  it "returns the build data" do
    stub_request(:get, "www.example.com/build_data").to_return(body: "some build data")
    subject.grab_build_data.should == "some build data"
  end

  it "returns the an exception it the response code is not 200" do
    stub_request(:get, "www.example.com/build_data").to_return(body: "some build data", status: 404)
    expect { subject.grab_build_data }.to raise_error(UnableToGrabDataFromJenkins, "Response code 404")
  end

  it "returns the an exception the request times out" do
    stub_request(:get, "www.example.com/build_data").to_timeout
    expect { subject.grab_build_data }.to raise_error(UnableToGrabDataFromJenkins, "Request timed out")
  end
end

