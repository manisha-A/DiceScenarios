require 'page-object'
class DiceBasePage
  include PageObject

  button(:submit_button, :css => '[type="submit"]')

  def select_menu_option(menu_options, value)
    menu_options.each { |option|
      puts option.text
      if option.text.include? value
        option.click
        break
      end
    }
  end

  def scroll_element_to_view(element)
    execute_script('arguments[0].scrollIntoView(true);', element)
  end
end