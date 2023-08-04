require 'page-object'
class DiceBasePage
  include PageObject

  button(:submit_button, :css => '[type="submit"]')
end