class SignInCard
  include Capybara::DSL

  def login_with(email, password)
    within(find('.content-section')) do
      fill_in('user_email', with: email)
      fill_in('user_password', with: password)
      click_button("Sign in")
    end
  end
end
