# frozen-string-literal: true

require 'spec_helper'

describe 'Simple Practice Test' do
  before(:each) do
    visit('/')
    @sign_in_card = SignInCard.new
  end

  it 'Returns an error if incorrect credentials' do
    error_message = "Enter the email associated with your account and double-check"\
      " your password. If you're still having trouble, you can reset your password."
    @sign_in_card.login_with(ENV['INCORRECT_EMAIL'], ENV['INCORRECT_PWD'])
    within(find('.alert-container')) do
      expect(page).to have_content error_message
    end
  end

end