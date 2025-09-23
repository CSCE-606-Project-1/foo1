require "capybara/rspec"
require "selenium-webdriver"

Capybara.register_driver :selenium_chrome_headless_safe do |app|
  opts = Selenium::WebDriver::Chrome::Options.new
  opts.add_argument("--headless=new")
  opts.add_argument("--no-sandbox")
  opts.add_argument("--disable-dev-shm-usage")
  opts.add_argument("--disable-gpu")
  opts.add_argument("--window-size=1400,1400")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts)
end
