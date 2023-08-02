require 'page-object'
class DiceEvents
  include PageObject

  div(:event_published_message, :css => '.EventSuccess__HeaderText-sc-iib5cz-2')
  element(:event_header, :css => '.EventHeaderData__EventTitle-sc-2npiyx-5')
  button(:go_to_event, :css => '[data-id="goToEvent"]')
  button(:show_event_on_dice_web, :css => '[data-id="showOnDiceButton"]')

  def go_to_created_event
    self.go_to_event
  end

  def event_published_message
    self.event_published_message
  end

  def event_header
    self.event_header_element
  end

  def open_event_on_dice_web
    self.show_event_on_dice_web
  end
end