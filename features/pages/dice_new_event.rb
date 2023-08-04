require 'page-object'
require 'selenium-webdriver'
require 'rspec'
require 'date'

class DiceNewEvent < DiceBasePage

  page_url "https://mio-aqa-candidates.dc.dice.fm/events/new"

  element(:dice_new_event_page_title, :css => '.Page__PageTitle-sc-qnn1er-3')

  # Basic widget elements
  element(:basic_widget_eventType, :css => '[data-id="wizardStep[basics]"] .react-select__indicators')
  text_field(:basic_widget_title, :css => '[name="name"]')
  text_field(:basic_widget_genre, :id => 'genres')
  div(:basic_widget_menu_options, :css => '.react-select__menu')
  div(:basic_widget_menu_list, :css => '.react-select__menu-list')
  elements(:select_options, :css => '.react-select__option')
  text_field(:basic_widget_primary_venue, :id => 'primaryVenue')
  element(:basic_widget_venue_map, :css => '.MapboxMap__Link-sc-phv1in-0')

  # Timeline widget elements
  element(:timeline_widget_step_indicator, :css => '[data-id="stepIndicator[timeline]"]')
  element(:timeline_widget_header, :css => '[data-id="wizardStep[timeline]"] .FormHeader__NoMarginH2-sc-5b5iop-0')
  element(:timeline_widget_timezone, :css => '[data-id="wizardStep[timeline]"] .react-select__indicators')
  text_field(:timeline_widget_announce_date, :css => '[name="announceDate"]')

  text_field(:timeline_widget_on_sale_date, :css => '[name="onSaleDate"]')
  text_field(:timeline_widget_off_sale_date, :css => '[name="offSaleDate"]')
  text_field(:timeline_widget_start_date, :css => '[name="date"]')
  text_field(:timeline_widget_end_date, :css => '[name="endDate"]')

  # Information widget elements
  list_item(:information_widget_step_indicator, :css => '[data-id="stepIndicator[information]"]')
  element(:information_widget_step, :css => '[data-id="wizardStep[information]"]')

  file_field(:information_widget_upload_image, :css => '[name="eventImages"]')
  div(:information_widget_description, :css => '.public-DraftEditor-content')
  div(:description, :css => '.rdw-editor-main')
  div(:description_id, :id => 'placeholder-4r9kc')
  element(:description_span, :css => '[data-offset-key="9o9dq-0-0"]')

  text_field(:information_widget_covid, :css => '[name="eventRules.covidPolicyUrl"]')

  # Tickets widget elements
  list_item(:tickets_widget_step_indicator, :css => '[data-id="stepIndicator[tickets]"]')
  element(:tickets_widget_step, :css => '[data-id="wizardStep[tickets]"]')
  button(:tickets_widget_add_ticket, :css => '[data-id="wizardStep[tickets]"] button')
  button(:tickets_widget_settings, :css => '[data-id="ticketsSettings')
  checkbox(:tickets_widget_seated_event, :css => '[name="flags.seated.active')

  button(:tickets_widget_standing_ticket, :css => '[data-id="iconButton[standing]"]')
  button(:tickets_widget_add_second_ticket, :css => '.ListAddButton__AddButton-sc-f24vz4-0')
  button(:tickets_widget_unreserved_seating_ticket, :css => '[data-id="iconButton[unreserved_seating]"]')

  text_field(:tickets_widget_face_value, :css => '[name="faceValue"]')
  text_field(:tickets_widget_ticket_allocation, :css => '[name="allocation"]')
  button(:tickets_widget_save_ticket, :css => '.Modal__ModalFooter-sc-1pb5y5w-7 button')
  element(:added_ticket, :css => 'data-name="ticketTypes"]')

  # Settings widget elements
  text_area(:internal_notes, :css => '[name="extraNotes"]')
  div(:event_preview, :css => '.EventPreview__SForm-sc-1s6s4hp-0.hwCQJo')
  list_item(:settings_widget_step_indicator, :css => '[data-id="stepIndicator[settings]"]')
  button(:save_event_button, :css => '[data-id="saveButton"]')
  element(:draft_event_toast, :css => '.NotificationMessage__NotificationMessageText-sc-bpi9fk-2')

  button(:submit_event_button, :css => '.Modal__ModalFooter-sc-1pb5y5w-7 button')
  div(:review_popup, :css => '.Modal__ModalDialog-sc-1pb5y5w-2')

  def get_page_title
    self.dice_new_event_page_title
  end

  def fill_in_event_details(event_type, genre, venue_name)
    self.basic_widget_eventType_element.click

    select_menu_option(self.select_options_elements, event_type)
    self.basic_widget_title = generate_event_title

    scroll_element_to_view(basic_widget_title_element)
    self.basic_widget_genre = genre
    sleep 4

    self.basic_widget_menu_options_element.click

    scroll_element_to_view(basic_widget_genre_element)
    self.basic_widget_primary_venue = venue_name
    sleep 3

    self.basic_widget_menu_options_element.click
    is_venue_map_loaded
  end

  def go_to_timeline_step
    self.timeline_widget_step_indicator_element
  end

  def fill_in_event_timeline
    todays_date = Date.today
    event_announce_date = Date.today - 1
    off_sale_date = Date.today + 1
    event_start_date = Date.today + 4
    event_end_date = Date.today + 5

    self.timeline_widget_announce_date = format_event_date(event_announce_date)
    self.timeline_widget_on_sale_date = format_event_date(todays_date)
    self.timeline_widget_off_sale_date = format_event_date(off_sale_date)
    self.timeline_widget_start_date = format_event_date(event_start_date)
    self.timeline_widget_end_date = format_event_date(event_end_date)
  end

  def go_to_information_step
    self.information_widget_step_indicator
  end

  def upload_event_image()
    file_to_upload = Dir.pwd + "/features/support/test_data/image.jpg"
    self.information_widget_upload_image = file_to_upload
  end

  def add_ticket(ticket_type)
    case ticket_type
    when "Standing" then
      self.tickets_widget_add_ticket
      self.tickets_widget_standing_ticket
    when "Unreserved seating" then
      self.tickets_widget_add_second_ticket
      self.tickets_widget_unreserved_seating_ticket
    end
  end

  def enter_ticket_price(price)
    self.tickets_widget_face_value = price
  end

  def enter_ticket_allocation(allocation)
    self.tickets_widget_ticket_allocation = allocation
  end

  def save_ticket
    self.tickets_widget_save_ticket
  end

  def save_new_event
    self.settings_widget_step_indicator
    scroll_element_to_view(event_preview_element)
    self.save_event_button

    wait_until(10, 'draft event toast not visible') do
      self.draft_event_toast?
    end

    if(save_event_button == "CONTINUE")
      self.save_event_button
    end
    wait_until(10, 'review modal not found') do
      self.review_popup?
    end
  end

  def publish_event
    self.submit_event_button
    sleep 4
  end

  def go_to_tickets_step
    self.tickets_widget_step_indicator
    scroll_element_to_view(tickets_widget_seated_event_element)
  end

  def review_modal_text
    self.review_popup_element.text
  end

  def ticket_step_header
    self.tickets_widget_step_element
  end

  def enter_notes
    self.internal_notes = "Internal notes"
  end

  def select_event_timezone(timezone)
    scroll_element_to_view(timeline_widget_header_element)
    self.timeline_widget_timezone_element.click

    select_menu_option(self.select_options_elements, timezone)
  end

  def is_page_loaded
    wait_until(10, "New Event page not loaded") do
      self.dice_new_event_page_title?
    end
  end

  private

  def is_venue_map_loaded
    wait_until(10, "Venue map not loaded") do
      self.basic_widget_venue_map?
    end
  end

  def format_event_date(event_date)
    event_date.strftime("%a, %d %b %Y, %I:%M %p")
  end

  def generate_event_title
    "ft. Test Live Gig " + Time.now.to_i.to_s
  end

end