require "build_data_munger"

describe BuildDataMunger, "amalgamate" do
  it "should return the word green when all the builds are green" do
    build_data = %q{
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
    BuildDataMunger.new(build_data).amalgamate.should == "green"
  end

  it "should return green building when building" do
    build_data = %q{
    <xml>
      <build>
        <status>
          This build is Green and building 
        </status>
      </build>
      <build>
        <status>
          Green stuff
        </status>
      </build>
    </xml>}
    BuildDataMunger.new(build_data).amalgamate.should == "green building"
  end

  it "should return the word red when any of the builds are red" do
    build_data = %q{
    <xml>
      <build>
        <status>
          This build is red
        </status>
      </build>
      <build>
        <status>
          red stuff
        </status>
      </build>
    </xml>}
    BuildDataMunger.new(build_data).amalgamate.should == "red"
  end

  it "should return red building when building" do
    build_data = %q{
    <xml>
      <build>
        <status>
          This build is red and building 
        </status>
      </build>
      <build>
        <status>
          red stuff
        </status>
      </build>
    </xml>}
    BuildDataMunger.new(build_data).amalgamate.should == "red building"
  end
end
