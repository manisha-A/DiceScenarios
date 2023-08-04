require 'page-object'
class DiceWebHome < DiceBasePage

  # Dice Mio Web locators
  element(:dice_web_header, :css => '.HomePageHeaderLinks__Wrapper-sc-1vbht2z-8')
  button(:dice_web_buy_tickets, :css => '.EventDetailsCallToAction__ActionButton-sc-12zjeg-5')
  div(:dice_logo, :css => '.HomePageHeader__Logo-sc-15u1d7b-4')
  text_field(:find_an_event, :css => 'InlineSearch__Input-sc-3ue56x-0')
  element(:all_tickets, :css => '.PurchaseTickets__TicketTypes-sc-1hge6pd-16')
  elements(:all_ticket_options, :css => 'ul.PurchaseTickets__TicketTypes-sc-1hge6pd-16 li')
  button(:checkout_button, :css => '.dvVWIh')
  element(:user_phone_field, :css => '.PurchasePhone__Container-sc-1odqjnb-3')
  button(:phone_country_code, :css => '.PhoneField__SelectedButton-sc-1i75a8x-1')
  text_field(:search_country_code, :css => '.PhoneField__CodeSearchInput-sc-1i75a8x-4')
  element(:select_country_code, :css => '.PhoneField__ListItem-sc-1i75a8x-6')

  text_field(:user_phone_number, :css => '.PurchasePhone__SPhoneField-sc-1odqjnb-8 > input')
  text_field(:code_input, :css => '.CodeInput__Input-pxula4-2')

  # user details locators
  text_field(:user_first_name, :css => '[name="first_name"]')
  text_field(:user_last_name, :css => '[name="last_name"]')
  text_field(:user_email, :css => '[name="email"]')
  text_field(:user_dob, :css => '[name="dob"]')

  # card input locators
  element(:purchase_payment_methods, :css => '.PurchasePaymentMethod__PaymentMethods-dtjb3a-7')
  button(:purchase_ticket_button, :css => '.PurchasePaymentMethod__PurchaseTicketsButton-dtjb3a-5')
  text_field(:postcode, :css => '.Input__InputWrapper-g3cdq3-0 > input')

  element(:purchase_form_wrapper, :css => '.PurchaseAccount__FieldsWrapper-vd4vu8-1')
  element(:purchase_alert_popup, :css => '.PurchaseAlert__Container-sc-1hpuona-1')
  button(:purchase_alert_button, :css => '.PurchaseAlert__Button-sc-1hpuona-7')

  # ticket confirmation locators
  element(:ticket_confirmation_box, :css => '.TicketConfirmation__SConfirmationCard-wcouv1-1')
  element(:ticket_confirmation, :css => '.PurchaseCommon__StepTitle-sc-45o8j6-3')

  def buy_tickets
    self.dice_web_buy_tickets
  end

  def purchase_ticket_by_ticket_type(ticket_type)
    wait_until(10, "Tickets not loaded") do
      all_tickets?
    end
    self.all_ticket_options_elements.each { |option|
      if option.text.include? ticket_type
        option.click
      end
    }

    self.checkout_button
  end

  def dice_web_logo
    self.dice_logo_element
  end

  def find_an_event
    self.find_an_event_element
  end

  def enter_user_phone_details
    scroll_element_to_view(user_phone_field_element)

    self.phone_country_code
    self.search_country_code = '+44'
    self.select_country_code_element.click
    self.user_phone_number = '7455227865'
    submit_button
    self.code_input = '1111'

    if(purchase_alert_popup?)
      self.purchase_alert_button
    end
  end

  def enter_card_details
    wait_until(15, "payment methods not visible") do
      purchase_payment_methods?
    end

    in_iframe(:css => 'iframe[name^="__privateStripeFrame"]') do |iframe|
      text_field_element(:css => '[name="cardnumber"]', :frame => iframe).set '4111 1111 1111 1111'
      text_field_element(:css => '[name="exp-date"]', :frame => iframe).set '11/24'
      text_field_element(:css => '[name="cvc"]', :frame => iframe).set '123'
      sleep 2
    end
    self.postcode = 'EC1MED'
    self.purchase_ticket_button

    wait_until(30, 'ticket is not confirmed yet') do
      ticket_confirmation_box?
    end
  end
  def get_confirmation_message
    self.ticket_confirmation_element.text
  end

  def is_on_dice_web_home
    self.dice_web_header_element.text
  end
end