require "sinatra/base"
class BuildLights < Sinatra::Base
  get "/" do
    "green"
  end
end
