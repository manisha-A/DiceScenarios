require 'rubygems'
require 'rspec'
require 'date'

And(/^I am logged in to MIO as mio user$/) do
  @driver.find_element(:css,'[name="email"]').send_keys 'client_admin_auto@dice.fm'
  @driver.find_element(:css,'[name="password"]').send_keys 'musicforever'
  @driver.find_element(:css,'[type="submit"]').click
  sleep(5)

  # verify on Dashboard landing page
  get_page_title = @driver.find_element(:css, '.Page__PageTitle-sc-qnn1er-3').text
  expect(get_page_title).to eq('Dashboard')
end

When(/^I create a new event$/) do
  @driver.navigate.to('https://mio-aqa-candidates.dc.dice.fm/events/new')
  sleep(5)

  # verify on New Event landing page
  get_page_title = @driver.find_element(:css, '.Page__PageTitle-sc-qnn1er-3').text
  expect(get_page_title).to eq('New event')
end

Given(/^I am on MIO website$/) do
  @driver.navigate.to "https://mio-aqa-candidates.dc.dice.fm/"          #navigate to MIO website
end

And(/^I enter (.*) and (.*) for event details$/) do |genre, venue_name|
  #basic widget
  title = "ft. Test Live Gig " + Time.now.to_i.to_s
  @driver.find_element(:css,'[name="name"]').send_keys title

  @driver.find_element(:id, 'genres').send_keys genre
  sleep(5)
  @driver.find_element(:id, 'genres').send_keys :tab

  @driver.find_element(:id,'primaryVenue').send_keys venue_name
  sleep(3)
  @driver.find_element(:id, 'primaryVenue').send_keys :tab
end

And(/^I fill in event timeline$/) do
  #timezoneName
  #Timeline
  @driver.find_element(:css,'[data-id="stepIndicator[timeline]"]').click

  todays_date = Date.today
  event_announce_day = Date.today - 1
  off_sale_date = Date.today + 1
  event_date = Date.today + 4

  #Keep announce date 1 day before
  @driver.find_element(:css,'[name="announceDate"]').send_keys event_announce_day.strftime("%a, %d %b %Y, %I:%M %p"), :enter

  #sale on day today and sale off day 2 days later
  @driver.find_element(:css,'[name="onSaleDate"]').send_keys todays_date.strftime("%a, %d %b %Y, %I:%M %p"), :enter
  @driver.find_element(:css,'[name="offSaleDate"]').send_keys off_sale_date.strftime("%a, %d %b %Y, %I:%M %p"), :enter

  #even day today + 2 days later
  @driver.find_element(:css,'[name="date"]').send_keys event_date.strftime("%a, %d %b %Y, %I:%M %p"), :enter
  @driver.find_element(:css,'[name="endDate"]').send_keys event_date.strftime("%a, %d %b %Y, %I:%M %p"), :enter
end

And(/^I fill in event information$/) do
  #Information widget
  @driver.execute_script("arguments[0].scrollIntoView(true);", @driver.find_element(:css,'[data-id="stepIndicator[information]"]'))
  @driver.find_element(:css,'[data-id="stepIndicator[information]"]').click
  sleep(5)

  #Enter description
  file_to_upload = Dir.pwd + "/image.jpg"
  @driver.find_element(:css,'[name="eventImages"]').send_keys file_to_upload

  description_box = @driver.find_element(:css, '.public-DraftEditor-content')
  @driver.execute_script("arguments[0].scrollIntoView(true);", description_box)
  description_box.send_keys 'This is a test event description'
end

And(/^I add (.*) tickets$/) do |ticket_allocation|
  #Tickets widget


  # @driver.find_element(:css,'[name="allocation"]').clear




  allocated_tickets = @driver.find_element(:css,'[data-id="ticketSummary.totalAllocation"]')
  @driver.execute_script("arguments[0].scrollIntoView(true);", allocated_tickets)
  # expect(ticket_allocation.text).to eq('2')
end

And(/^I save event and continue$/) do
  @driver.find_element(:css,'[data-id="stepIndicator[settings]"]').click

  @driver.find_element(:css,'[data-id="saveButton"]').click
  sleep(5)
end

And(/^I submit event$/) do
  # Assert modal
  expect(@driver.find_element(:css,'.Modal__ModalDialog-sc-1pb5y5w-2').text).to include('Review details')

  # create event
  # @driver.find_element(:css,'.Modal__ModalFooter-sc-1pb5y5w-7 button').click
end

Then(/^the event should be published$/) do
  # expect(@driver.find_element(:css,'.EventSuccess__HeaderText-sc-iib5cz-2').text).to include('your event’s been published')
end

And(/^I add tickets for (.*)$/) do |ticket_type|
  @driver.find_element(:css,'[data-id="stepIndicator[tickets]"]').click
  expect(@driver.find_element(:css,'[data-id="wizardStep[tickets]"]').text).to include('Tickets')

  #Add a ticket
  case ticket_type
  when "Standing" then
    add_ticket = @driver.find_element(:css,'[data-id="wizardStep[tickets]"] button')
    sleep(3)
    add_ticket.click
    @driver.find_element(:css,'[data-id="iconButton[standing]"]').click
  when "Unreserved seating" then
    @driver.find_element(:css,'.ListAddButton__AddButton-sc-f24vz4-0').click
    @driver.find_element(:css,'[data-id="iconButton[unreserved_seating]"]').click
  end

  @driver.find_element(:css,'[name="faceValue"]').send_keys "10.00"

  sleep(3)
  # @driver.execute_script("arguments[0].value = ''", @driver.find_element(:css,'[name="allocation"]'));
  @driver.find_element(:css,'[name="allocation"]').send_keys ""
  @driver.find_element(:css,'[name="allocation"]').send_keys 2
  @driver.find_element(:css,'.Modal__ModalFooter-sc-1pb5y5w-7 button').click
end