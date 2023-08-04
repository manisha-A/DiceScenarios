require 'page-object'
class DiceMioEvents
  include PageObject

  div(:event_published_message, :css => '.EventSuccess__HeaderText-sc-iib5cz-2')
  element(:event_header, :css => '.EventHeaderData__EventTitle-sc-2npiyx-5')
  button(:go_to_event, :css => '[data-id="goToEvent"]')
  button(:show_event_on_dice_web, :css => '[data-id="showOnDiceButton"]')
  div(:event_success_container, :css => '.EventSuccess__Container-sc-iib5cz-1')

  def go_to_created_event
    self.go_to_event
  end

  def event_published_message
    self.event_success_container_element.text
  end

  def event_header
    self.event_header_element
  end

  def open_event_on_dice_web
    self.show_event_on_dice_web
  end

  def is_on_page
    wait_until(5, 'Success not found on page') do
      self.event_success_container_element.text.include? 'published'
    end
  end

  def is_event_on_sale
    wait_until(5, 'Success not found on page') do
      self.event_header_element.text.include? 'sale'
    end
  end
end