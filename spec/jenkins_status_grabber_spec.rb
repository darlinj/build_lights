require "jenkins_status_grabber"

describe JenkinsStatusGrabber, "initialization" do
  it "should prepare the url" do
    Configuration.stub(:jenkins_url).and_return("some url")
    URI.should_receive(:parse).with("some url")
    JenkinsStatusGrabber.new( mock )
  end
end

describe JenkinsStatusGrabber, "grab_build_data" do
  let(:grabber_library) { mock }
  let(:a_response) { mock("response", code: "200", body: "some text") }

  before do
    Configuration.stub(:jenkins_url)
    URI.stub(:parse).and_return("some url")
    grabber_library.stub(:get_response).and_return(a_response)
  end

  it "should make a request to the jenkins web page" do
    grabber_library.should_receive(:get_response).with("some url")
    JenkinsStatusGrabber.new( grabber_library ).grab_build_data
  end

  context "when the grab is successful" do

    it "should return the page data" do
      JenkinsStatusGrabber.new( grabber_library ).grab_build_data.should == "some text"
    end
  end

  context "when the response code is not 200" do
    before do
      a_response.stub(:code).and_return(404)
    end

    it "should raise an exception containing the reponse status" do
      expect { JenkinsStatusGrabber.new( grabber_library ).grab_build_data }.to raise_error(UnableToGrabDataFromJenkins, "Response code 404")
    end
  end

  context "when the request to get the page raises an exception" do
    class SocketError < RuntimeError

    end

    before do
      a_response.stub(:code).and_raise SocketError
    end

    it "should raise an exception containing the reponse status" do
      expect { JenkinsStatusGrabber.new( grabber_library ).grab_build_data }.to raise_error(UnableToGrabDataFromJenkins, "Socket error - Possibly a problem with the configured uri for Jenkins")
    end
  end

end
