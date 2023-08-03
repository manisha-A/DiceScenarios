require 'rubygems'
require 'rspec'
require 'date'
require_relative '../pages/dice_mio_login.rb'
require_relative '../pages/dice_mio_home.rb'
require_relative '../pages/dice_new_event.rb'
require_relative '../pages/dice_mio_events.rb'

Given(/^I am on MIO website$/) do
  @driver.navigate.to "https://mio-aqa-candidates.dc.dice.fm/"          #navigate to MIO website
end

And(/^I am logged in to MIO as mio user$/) do
  # @driver.find_element(:css,'[name="email"]').send_keys 'client_admin_auto@dice.fm'
  # @driver.find_element(:css,'[name="password"]').send_keys 'musicforever'
  # @driver.find_element(:css,'[type="submit"]').click
  # sleep(5)

  @loginpage = DiceMioLogin.new(@driver, true)
  @loginpage.login_as_user('client_admin_auto@dice.fm', 'musicforever')

  @dice_home_page = DiceMioHome.new(@driver)

  # verify on Dashboard landing page
  get_page_title = @dice_home_page.get_page_title
  expect(get_page_title).to eq('Dashboard')
end

When(/^I create a new event$/) do
  @dice_new_event_page = DiceNewEvent.new(@driver, true)
  # @driver.navigate.to('https://mio-aqa-candidates.dc.dice.fm/events/new')
  sleep(5)
  #todo: fix wait time

  # verify on New Event landing page
  expect(@dice_new_event_page.get_page_title).to eq('New event')
end

And(/^I enter (.*) and (.*) for event details$/) do |genre, venue_name|
  #basic widget
  event_title = "ft. Test Live Gig " + Time.now.to_i.to_s
  @dice_new_event_page.fill_in_event_details(event_title,genre,venue_name)
  # @driver.find_element(:css,'[name="name"]').send_keys title

  # @driver.find_element(:id, 'genres').send_keys genre

  # sleep(5)
  # @dice_new_event_page.send :tab
  # @driver.find_element(:id, 'genres').send_keys :tab

  # @driver.find_element(:id,'primaryVenue').send_keys venue_name
  # sleep(3)
  # @dice_new_event_page.send :tab
end

And(/^I fill in event timeline$/) do
  #timezoneName
  #Timeline
  # @driver.find_element(:css,'[data-id="stepIndicator[timeline]"]').click

  todays_date = Date.today
  event_announce_day = Date.today - 1
  off_sale_date = Date.today + 1
  event_start_date = Date.today + 4
  event_end_date = Date.today + 5

  #Keep announce date 1 day before
  # @driver.find_element(:css,'[name="announceDate"]').send_keys event_announce_day.strftime("%a, %d %b %Y, %I:%M %p"), :enter

  #sale on day today and sale off day 2 days later
  # @driver.find_element(:css,'[name="onSaleDate"]').send_keys todays_date.strftime("%a, %d %b %Y, %I:%M %p"), :enter
  # @driver.find_element(:css,'[name="offSaleDate"]').send_keys off_sale_date.strftime("%a, %d %b %Y, %I:%M %p"), :enter

  #even day today + 2 days later
  # @driver.find_element(:css,'[name="date"]').send_keys event_date.strftime("%a, %d %b %Y, %I:%M %p"), :enter
  # @driver.find_element(:css,'[name="endDate"]').send_keys event_date.strftime("%a, %d %b %Y, %I:%M %p"), :enter
  @dice_new_event_page.go_to_timeline_step
  @dice_new_event_page.fill_in_event_timeline(event_announce_day,todays_date,off_sale_date,event_start_date,event_end_date)
end

And(/^I fill in event information$/) do
  @dice_new_event_page.go_to_information_step
  # @driver.execute_script("arguments[0].scrollIntoView(true);", @driver.find_element(:css,'[data-id="stepIndicator[information]"]'))
  # @driver.find_element(:css,'[data-id="stepIndicator[information]"]').click
  # sleep(5)

  #Enter description
  file_to_upload = Dir.pwd + "/image.jpg"
  @dice_new_event_page.upload_event_image(file_to_upload)
  # @dice_new_event_page.add_event_description

  description_box = @driver.find_element(:css, '.public-DraftEditor-content')
  # @driver.execute_script("arguments[0].scrollIntoView(true);", description_box)
  description_box.send_keys 'This is a test event description'
end

And(/^I save event and continue$/) do
  @dice_new_event_page.save_new_event
  # sleep(5)
end

And(/^I submit event$/) do
  # Assert modal
  expect(@dice_new_event_page.review_modal_text).to include('Review details')

  # publish event
  @dice_new_event_page.publish_event
end

Then(/^the event should be published and can be preview$/) do
  @dice_events_page = DiceMioEvents.new(@driver)
  @dice_events_page.is_on_page
  expect(@dice_events_page.event_published_message).to include('your event’s been published')
  # expect(@driver.find_element(:css,'.EventSuccess__HeaderText-sc-iib5cz-2').text).to include('your event’s been published')
  # @driver.find_element(:css,'[data-id="goToEvent"]').click
  @dice_events_page.go_to_created_event
  sleep(2)

  expect(@dice_events_page.event_header.text).to include('On sale')
  # event_header = @driver.find_element(:css,'.EventHeaderData__EventTitle-sc-2npiyx-5')
  # printf(event_header.text)
  # expect(event_header.text).to include('On sale')
end

And(/^I add tickets for (.*)$/) do |ticket_type|
  @dice_new_event_page.go_to_tickets_step
  expect(@dice_new_event_page.ticket_step_header.text).to include('Tickets')

  #Add a ticket
  @dice_new_event_page.add_ticket(ticket_type)

  @dice_new_event_page.enter_ticket_price(10.00)
  @dice_new_event_page.enter_ticket_allocation(2)

  @dice_new_event_page.save_ticket

  # @driver.execute_script("arguments[0].value = ''", @driver.find_element(:css,'[name="allocation"]'));
  # @driver.find_element(:css,'[name="allocation"]').send_keys ""
  # @driver.find_element(:css,'[name="allocation"]').send_keys 2
  # @driver.find_element(:css,'.Modal__ModalFooter-sc-1pb5y5w-7 button').click
end

# show on Dice
And(/^I should be able to see view event on Dice Web$/) do
  @dice_events_page.open_event_on_dice_web
  # @driver.find_element(:css,'[data-id="showOnDiceButton"]').click
  @driver.switch_to.window(@driver.window_handles[1])
  sleep 10
  @dice_web_home_page = DiceWebHome.new(@driver)

  # expect(@dice_web_home_page.find_an_event).to exist
  # expect(@driver.find_element(:css,'.HomePageHeader__Logo-sc-15u1d7b-4')).should exist
end

And(/^I add internal notes$/) do
  @dice_new_event_page.enter_notes
end