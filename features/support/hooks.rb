require 'rubygems'
require 'selenium-webdriver'

Before do
  Selenium::WebDriver::Chrome::Service.driver_path = ENV['CHROMEDRIVER']
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--disable-gpu')

  caps = Selenium::WebDriver::Remote::Capabilities.chrome

  @driver = Selenium::WebDriver.for :chrome, options: options, capabilities: caps
end

After do
  @driver.quit
end