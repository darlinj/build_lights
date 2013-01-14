require 'amalgamate_builds'

describe AmalgamateBuilds::Amalgamate, "status" do
  let(:jenkins_build_grabber) { mock }
  let(:build_data_munger)     { mock("data munger", amalgamate: "green") }

  before do
    JenkinsStatusGrabber.stub(:new).and_return jenkins_build_grabber
    jenkins_build_grabber.stub(:grab_build_data).and_return("some data")
    BuildDataMunger.stub(:new).and_return(build_data_munger)
  end

  it "will grab the build details" do
    jenkins_build_grabber.should_receive(:grab_build_data)
    subject.status
  end

  it "will create a data munger" do
    BuildDataMunger.should_receive(:new).with("some data")
    subject.status
  end

  it "will amalgamate them" do
    build_data_munger.should_receive(:amalgamate)
    subject.status
  end

  it "will return the amalgamated value" do
    subject.status.should == "green"
  end
end
