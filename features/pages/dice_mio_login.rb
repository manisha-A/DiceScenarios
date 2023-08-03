require 'page-object'

class DiceMioLogin
  include PageObject

  page_url "https://mio-aqa-candidates.dc.dice.fm/"
  text_field(:email, :css => '[name="email"]')
  text_field(:password, :css => '[name="password"]')
  button(:login, :css => '[type="submit"]')

  def login_as_user(username, password)
    self.email = username
    # self.email
    self.password = password
    login
  end

end