require 'rubygems'
require 'rspec'
require_relative '../pages/dice_mio_login.rb'
require_relative '../pages/dice_mio_home.rb'
require_relative '../pages/dice_new_event.rb'
require_relative '../pages/dice_mio_events.rb'

Given(/^I am on MIO website$/) do
  @driver.navigate.to "https://mio-aqa-candidates.dc.dice.fm/"
end

And(/^I am logged in to MIO as mio user$/) do
  @loginpage = DiceMioLogin.new(@driver, true)
  @loginpage.login_as_user('client_admin_auto@dice.fm', 'musicforever')

  @dice_home_page = DiceMioHome.new(@driver)

  # verify on Dashboard landing page
  get_page_title = @dice_home_page.get_page_title
  expect(get_page_title).to eq('Dashboard')
end

When(/^I create a new event$/) do
  @dice_new_event_page = DiceNewEvent.new(@driver, true)
  @dice_new_event_page.is_page_loaded
  # sleep(5)
  #todo: fix wait time

  # verify on New Event landing page
  expect(@dice_new_event_page.get_page_title).to eq('New event')
end

And(/^I enter (.*),(.*) and (.*) for event details$/) do |event_type, genre, venue_name|
  # enter event details
  @dice_new_event_page.fill_in_event_details(event_type,genre,venue_name)
end

And(/^I fill in event (.*) and timeline$/) do |timezone|
  @dice_new_event_page.go_to_timeline_step
  @dice_new_event_page.select_event_timezone(timezone)
  @dice_new_event_page.fill_in_event_timeline
end

And(/^I fill in event information$/) do
  # Enter event information
  @dice_new_event_page.go_to_information_step
  @dice_new_event_page.upload_event_image

  description_box = @driver.find_element(:css, '.public-DraftEditor-content')
  description_box.send_keys 'This is a test event description'
end

And(/^I save event and continue$/) do
  @dice_new_event_page.save_new_event
end

And(/^I submit event$/) do
  # Assert modal
  expect(@dice_new_event_page.review_modal_text).to include('Review details')

  # publish event
  @dice_new_event_page.publish_event
end

Then(/^the event should be published and can be previewed$/) do
  @dice_events_page = DiceMioEvents.new(@driver)
  @dice_events_page.is_on_page
  expect(@dice_events_page.event_published_message).to include('your event’s been published')

  @dice_events_page.go_to_created_event
  sleep(2)

  expect(@dice_events_page.event_header.text).to include('On sale')
end

And(/^I add tickets for (.*)$/) do |ticket_type|
  @dice_new_event_page.go_to_tickets_step
  expect(@dice_new_event_page.ticket_step_header.text).to include('Tickets')

  #Add a ticket
  @dice_new_event_page.add_ticket(ticket_type)

  @dice_new_event_page.enter_ticket_price(10.00)
  @dice_new_event_page.enter_ticket_allocation(2)

  @dice_new_event_page.save_ticket
end

And(/^I should be able to see view event on Dice Web$/) do
  # Event on Dice Web
  @dice_events_page.open_event_on_dice_web

  @driver.switch_to.window(@driver.window_handles[1])
  sleep 10
  @dice_web_home_page = DiceWebHome.new(@driver)

end

And(/^I add internal notes$/) do
  @dice_new_event_page.enter_notes
end