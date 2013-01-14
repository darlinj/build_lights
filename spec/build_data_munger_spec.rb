require "build_data_munger"

describe BuildDataMunger, "amalgamate" do
  it "should return the word green when all the builds are green" do
    build_data = %q{
    <xml>
      <build>
        <title>
          This build is Green
        </title>
      </build>
      <build>
        <title>
          Green stuff
        </title>
      </build>
    </xml>}
    BuildDataMunger.new(build_data).amalgamate.should == "green"
  end

  it "should return the word red when any of the builds are red" do
    build_data = %q{
    <xml>
      <build>
        <title>
          This build is broken
        </title>
      </build>
      <build>
        <title>
          broken stuff
        </title>
      </build>
    </xml>}
    BuildDataMunger.new(build_data).amalgamate.should == "red"
  end

end
