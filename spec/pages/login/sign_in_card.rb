# frozen-string-literal: true

class SignInCard
  include Capybara::DSL

  def initialize(session)
    @session = session
  end

  def login_with(email, password)
    within(@session.find('.content-section')) do
      @session.fill_in('user_email', with: email)
      @session.fill_in('user_password', with: password)
      @session.click_button('Sign in')
    end
  end
end
