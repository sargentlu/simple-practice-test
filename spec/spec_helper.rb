# frozen-string-literal: true
require 'capybara/rspec'
require 'capybara/dsl'
require 'dotenv/load'
require 'rspec'
require 'selenium-webdriver'

pages  = File.join(Dir.pwd, 'spec/pages/**/*.rb')
Dir.glob(pages).each { |file| require file }

Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.default_driver = :firefox
Capybara.app_host = 'https://secure.simplepractice.com/'
Capybara.default_max_wait_time = 5

RSpec.configure do |config|
  config.before(:each) do
    config.include Capybara::DSL
  end
end
