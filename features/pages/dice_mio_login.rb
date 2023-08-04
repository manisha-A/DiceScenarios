require 'page-object'
class DiceMioLogin < DiceBasePage

  # Dice Mio Login locators
  page_url "https://mio-aqa-candidates.dc.dice.fm/"
  text_field(:email, :css => '[name="email"]')
  text_field(:password, :css => '[name="password"]')

  def login_as_user(username, password)
    self.email = username
    self.password = password
    submit_button
  end

end