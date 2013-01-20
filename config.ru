require 'bundler'
Bundler.require
require File.join(File.dirname(__FILE__), 'lib', 'build_lights')

map '/' do
    run BuildLights
end

