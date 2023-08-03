require 'rubygems'
require 'rspec'

When(/^I proceed to buy tickets on Dice events home page$/) do
  @dice_web_home_page = DiceWebHome.new(@driver)
  @dice_web_home_page.buy_tickets
end

And(/^I purchase tickets for (.*)$/) do |second_ticket_type|
  @dice_web_home_page.purchase_ticket_by_ticket_type(second_ticket_type)
end

And(/^I enter details as a new user$/) do
  @dice_web_home_page.enter_user_phone_details
end

And(/^I enter card details$/) do
  @dice_web_home_page.enter_card_details
end

Then(/^I should see ticket confirmation$/) do
  expect(@dice_web_home_page.get_confirmation_message).to include('Confirmation')
end