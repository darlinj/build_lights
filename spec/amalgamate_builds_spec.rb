require 'amalgamate_builds'
require 'jenkins_status_grabber'

describe AmalgamateBuilds, "status" do
  let(:jenkins_build_grabber) { mock }
  before do
    JenkinsStatusGrabber.stub(:new).and_return jenkins_build_grabber
  end
  it "will grab the build details" do
    jenkins_build_grabber.should_receive(:grab_build_data)
    subject.status
  end
  it "will amalgamate them"
  it "will return the amalgamated value"
end
