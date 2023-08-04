require 'page-object'
class DiceMioHome
  include PageObject

  # Dice Mio Dashboard locators
  element(:dice_dashboard_title, :css => '.Page__PageTitle-sc-qnn1er-3')
  def get_page_title
    self.dice_dashboard_title
  end
end