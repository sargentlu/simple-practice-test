# frozen-string-literal: true

require 'spec_helper'
require 'sekrets'

describe 'Simple Practice Test' do
  secrets_settings = Sekrets.settings_for('settings.yml.enc')
  secrets = Hash.new

  if secrets_settings
    secrets_settings.split.each do |item|
      key, value = item.split('=')
      secrets[key] = value
    end
  end

  email = secrets['USER_EMAIL']
  password = secrets['USER_PWD']
  incorrect_email = secrets['INCORRECT_EMAIL']
  incorrect_password = secrets['INCORRECT_PWD']
  first_name = secrets['CLIENT01_FIRST_NAME']
  last_name = secrets['CLIENT01_LAST_NAME']

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

    @sign_in_card.login_with(incorrect_email, incorrect_password)

    expect(@session.find('.alert-container')).to have_content error_message
  end

  it 'Creates a client with the minimum required info' do
    @sign_in_card.login_with(email, password)

    @new_client_card = NewClientCard.new(@session)
    @new_client_card.create_client(
      {
        'firstName': first_name,
        'lastName': last_name
      }
    )

    expect(true).to eq(true)
  end

  it 'Creates a client with more info' do
    @sign_in_card.login_with(email, password)

    @new_client_card = NewClientCard.new(@session)
    @new_client_card.create_client(
      {
        'firstName': first_name,
        'lastName': last_name,
        'nickname': 'Mul',
        'month': 'December',
        'day': 15,
        'year': 1999,
        'status': 'prospective',
        'waitlist': true,
        'office': 'Secoind',
        'email':  'mulatu@mail.com',
        'phone': '555-555-5555'
      }
    )

    expect(true).to eq(true)
  end

  it 'Verifies the created client is present' do
    @clients_page = ClientsPage.new(@session)
    @sign_in_card.login_with(email, password)

    client = @clients_page.search_client(first_name, last_name)
    expect(client['client_name']).to eq("%s %s" % [first_name, last_name])
  end

end