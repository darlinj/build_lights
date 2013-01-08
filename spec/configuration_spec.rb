require "configuration"

describe Configuration, "defining configuration parameters" do
  it "creates attr_accessors for the config values" do
    Configuration.config do
      parameter :foo
    end
    Configuration.foo
  end

  it "allows you to set the values of the parameters" do
    Configuration.config do
      parameter :foo
      foo="fish"
    end
    Configuration.foo = "fish"
  end
end
