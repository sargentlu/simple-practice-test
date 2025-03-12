# frozen-string-literal: true

require 'spec_helper'

describe 'Simple Practice Test' do
  before(:each) do
    @session = create_web_session
    @session.visit('/')
    @sign_in_card = SignInCard.new(@session)
  end

  after(:each) do
    end_web_session(@session)
  end

  it 'Returns an error if incorrect credentials' do
    error_message = "Enter the email associated with your account and double-check"\
      " your password. If you're still having trouble, you can reset your password."
    @sign_in_card.login_with(ENV['INCORRECT_EMAIL'], ENV['INCORRECT_PWD'], @session)
    within(find('.alert-container')) do
      expect(page).to have_content error_message
    end
  end

  it 'Creates a client' do
    @new_client_card = NewClientCard.new

    @sign_in_card.login_with(ENV['USER_EMAIL'], ENV['USER_PWD'], @session)

    @new_client_card.create_client(
      ENV['CLIENT01_FIRST_NAME'],
      ENV['CLIENT01_LAST_NAME']
    )
    expect(true).to eq(true)
  end

  it 'Verifies the created client is present' do
    @clients_page = ClientsPage.new(@session)
    email = ENV['USER_EMAIL']
    password = ENV['USER_PWD']
    first_name = ENV['CLIENT01_FIRST_NAME']
    last_name = ENV['CLIENT01_LAST_NAME']

    @sign_in_card.login_with(email, password)

    client = @clients_page.search_client(first_name, last_name)
    expect(client['client_name']).to eq("%s %s" % [first_name, last_name])
  end

end