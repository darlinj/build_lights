require_relative '../../lib/build_lights'
require 'capybara/cucumber'
Capybara.app = BuildLights

When /^I access the root page$/ do
  visit "/"
end

Then /^I should see green$/ do
  page.should have_content("green")
end
