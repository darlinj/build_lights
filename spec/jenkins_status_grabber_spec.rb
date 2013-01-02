require "jenkins_status_grabber"
require "configuration"

describe JenkinsStatusGrabber, "grab_status" do
  let(:grabber_library) { mock }

  
  it "should make a request to the jenkins web page" do
    Configeration.stub(:jenkins_url).and_return("some url")
    grabber_library.should_receive(:get_response).with("some url")
    JenkinsStatusGrabber.new( grabber_library ).grab_status
  end

  context "when the grab is successful" do
    it "should return the page data" do
      grabber_library.stub(:get_response).and_return("some data")
      JenkinsStatusGrabber.new( grabber_library ).grab_status.should == "some data"
    end
  end
end
