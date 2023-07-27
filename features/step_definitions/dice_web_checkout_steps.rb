require 'rubygems'
require 'rspec'

When(/^I proceed to buy tickets on Dice events home page$/) do
  @driver.find_element(:css,'.EventDetailsCallToAction__ActionButton-sc-12zjeg-5').click
end

And(/^I purchase tickets for (.*)$/) do |second_ticket_type|
  find_all_options = @driver.find_elements(:css,'ul.PurchaseTickets__TicketTypes-sc-1hge6pd-16 li')
  find_all_options.each {|option|
    if option.text.include? second_ticket_type
      option.click
    end
  }

  @driver.find_element(:css,'.dvVWIh').click





end

Given(/^I go to event$/) do
  @driver.navigate.to('https://aqa-candidates.dc.dice.fm/event/43v8-test-event-2003454569-27th-jul-dice-venue-in-london-london-tickets')
end

And(/^I enter details as a new user$/) do
  @driver.execute_script("arguments[0].scrollIntoView(true);", @driver.find_element(:css,'.PurchasePhone__Container-sc-1odqjnb-3'))

  modal = @driver.find_element(:css,'.PurchasePhone__Container-sc-1odqjnb-3')
  modal.find_element(:css, '.PhoneField__Container-sc-1i75a8x-7 > input').send_keys '7455227865', :enter

  # @driver.find_element(:css, '.PhoneField__Container-sc-1i75a8x-7 > input').send_keys '7455227865'
  sleep(10)
  # modal.find_element(:css,'[type="submit"]').click
  # @driver.find_element(:css,'[type="submit"]').click

  # @driver.find_element(:css,'[type="tel"]').send_keys '07455227865',:enter
  # @driver.find_element(:css,'[type="submit"]').click
  # @driver.find_element(:css,'.PurchasePhone__NextButton-sc-1odqjnb-6').click

  @driver.find_element(:css,'.CodeInput__Input-pxula4-2').send_keys '1111'

  sleep(15)
end

And(/^I enter card details$/) do
  purchase_payment_methods = @driver.find_element(:css,'.PurchaseCheckout__SPurchasePaymentMethod-sc-7ddvrm-3')
  printf(purchase_payment_methods.text)
  # expect(purchase_payment_methods).to include?('Pay with card')

  #enter card details

  @driver.switch_to.frame(@driver.find_element(:css,'iframe[name^="__privateStripeFrame"]'))
  @driver.find_element(:css,'[name="cardnumber"]').send_keys '4111 1111 1111 1111'
  @driver.find_element(:css,'[name="exp-date"]').send_keys '11/24'
  @driver.find_element(:css,'[name="cvc"]').send_keys '123'
  # @driver.find_element(:css,'.Input__InputWrapper-g3cdq3-0 > input').send_keys 'EC1MED'
  @driver.find_element(:css,'.PurchasePaymentMethod__PurchaseTicketsButton-dtjb3a-5').click

  sleep(5)
  get_confirmation_box = @driver.find_element(:css,'.TicketConfirmation__SConfirmationCard-wcouv1-1')
  expect(get_confirmation_box).to include('THE TICKET IS ALL YOURS')
end