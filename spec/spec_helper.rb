# frozen-string-literal: true

require 'capybara/rspec'
require 'capybara/dsl'
require 'dotenv'
require 'rspec'
require 'selenium-webdriver'
require 'sekrets'

pages  = File.join(Dir.pwd, 'spec/pages/**/*.rb')
Dir.glob(pages).each { |file| require file }

secrets = Sekrets.settings_for('.env.enc')
if secrets
  secrets.split.each do |item|
    key, value = item.split('=')
    ENV[key] = value
  end
end

Dotenv.load

RSpec.configure do |config|
  config.before(:each) do
    config.include Capybara::DSL
  end
end

def create_web_session
  Capybara.app_host = 'https://secure.simplepractice.com/'
  Capybara.run_server = false
  Capybara.default_max_wait_time = 5

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
