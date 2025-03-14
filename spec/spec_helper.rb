# frozen-string-literal: true

require 'capybara/rspec'
require 'capybara/dsl'
require 'rspec'
require 'selenium-webdriver'
require 'sekrets'

# Load all page classes
pages  = File.join(Dir.pwd, 'spec/pages/**/*.rb')
Dir.glob(pages).each { |file| require file }

RSpec.configure do |config|
  config.before(:each) do
    config.include Capybara::DSL
  end
end

# Create a web session. Runs on a Chromium browser if present,
# unless the project is run locally in which case it's run on
# a Firefox browser
def create_web_session
  Capybara.app_host = 'https://secure.simplepractice.com/'
  Capybara.run_server = false
  Capybara.default_max_wait_time = 5
  Capybara.enable_aria_label = true

  if ENV['CHROME_URL']
    Capybara.register_driver :remote do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        options: Selenium::WebDriver::Options.chrome,
        url: ENV['CHROME_URL']
      )
    end
    @session = Capybara::Session.new(:remote)
  else
    Capybara.register_driver :remote do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        options: Selenium::WebDriver::Options.firefox
      )
    end
    @session = Capybara::Session.new(:selenium)
  end
end

def end_web_session(session)
  session.reset!
  session.driver.quit
end
