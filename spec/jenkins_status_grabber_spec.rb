require "jenkins_status_grabber"
require 'webmock/rspec'

describe JenkinsStatusGrabber, "grab_build_data" do
  it "returns the build data" do
    stub_request(:get, "www.example.com/build_data").to_return(body: "some build data")
    JenkinsStatusGrabber.new.grab_build_data("http://www.example.com/build_data").should == "some build data"
  end

  it "returns the an exception it the response code is not 200" do
    stub_request(:get, "www.example.com/build_data").to_return(body: "some build data", status: 404)
    expect { JenkinsStatusGrabber.new.grab_build_data("http://www.example.com/build_data") }.to raise_error(UnableToGrabDataFromJenkins, "Response code 404")
  end

  it "returns the an exception the request times out" do
    stub_request(:get, "www.example.com/build_data").to_timeout
    expect { JenkinsStatusGrabber.new.grab_build_data("http://www.example.com/build_data") }.to raise_error(UnableToGrabDataFromJenkins, "Request timed out")
  end
end

