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

  before(:each) do
    @session = create_web_session
    @session.visit('/')
    @sign_in_card = SignInCard.new(@session)
  end

  after(:each) do
    end_web_session(@session)
  end

  it 'Returns an error if trying to log in with incorrect credentials' do
    error_message = "Enter the email associated with your account and double-check"\
      " your password. If you're still having trouble, you can reset your password."

    @sign_in_card.login_with(incorrect_email, incorrect_password)

    expect(@session.find('.alert-container')).to have_content error_message
  end

  it 'Creates a client with the minimum required info' do
    client_info = {
      'firstName': 'Paul',
      'lastName': 'Lu'
    }

    @sign_in_card.login_with(email, password)

    @session.click_on(class: 'button-link button-navbar create')
    @session.click_on('Create client')
    expect(@session).to have_content('Create client')

    # In general, this could have been added inside within() blocks
    # to omit having to repeat 'new_client'. However, this was triggering an error
    new_client = @session.find('.prospective-client-ui')
    expect(new_client).to have_content('Create client')

    new_client.fill_in('firstName', with: client_info[:firstName])
    expect(new_client).to have_field('firstName', with: client_info[:firstName])
    new_client.fill_in('lastName', with: client_info[:lastName])
    expect(new_client).to have_field('lastName', with: client_info[:lastName])

    @session.click_button('Continue')
    # Added this sleep as expect fails to notice that
    # the new user modal has been closed
    sleep 0.5
    expect(@session).not_to have_content('Create client')

    expected_name = "%s %s" % [client_info[:firstName], client_info[:lastName]]

    @session.click_on('Clients')

    @session.find('.utility-bar').fill_in('utility-search', with: expected_name)
    # Added this sleep as expect fails to notice utility-search
    # was updated before its value is retrieved
    sleep 1
    expect(@session.find('.utility-bar')).to have_field('utility-search', with: expected_name)

    client_name = @session.first('.record-name').text

    expect(client_name).to eq(expected_name)
  end

  it 'Creates a client with more info' do
    client_info = {
      'firstName': 'Sergio',
      'lastName': 'Martinez',
      'month': 'December',
      'day': 15,
      'year': 1999,
      'office': 'Secoind',
      'email':  secrets['CLIENT_EMAIL'],
      'phone': secrets['CLIENT_PHONE']
    }

    @sign_in_card.login_with(email, password)

    @session.click_on(class: 'button-link button-navbar create')
    @session.click_on('Create client')
    expect(@session).to have_content('Create client')

    # In general, this could have been added inside within() blocks
    # to omit having to repeat 'new_client'. However, this was triggering an error
    new_client = @session.find('.prospective-client-ui')
    expect(new_client).to have_content('Create client')

    new_client.fill_in('firstName', with: client_info[:firstName])
    expect(new_client).to have_field('firstName', with: client_info[:firstName])
    new_client.fill_in('lastName', with: client_info[:lastName])
    expect(new_client).to have_field('lastName', with: client_info[:lastName])

    new_client.select client_info[:month], from: 'month'
    expect(new_client).to have_field('month', with: client_info[:month])
    new_client.select client_info[:day], from: 'day'
    expect(new_client).to have_field('day', with: client_info[:day])
    new_client.select client_info[:year], from: 'year'
    expect(new_client).to have_field('year', with: client_info[:year])

    new_client.select client_info[:office], from: 'office'
    expect(new_client).to have_field('office', with: 9096980)

    contact_details = new_client.find('.contact-details-section-container')

    contact_details.click_button('Add email')
    expect(contact_details).to have_content('email')
    contact_details.fill_in('email', with: client_info[:email])
    expect(contact_details).to have_field('email', with: client_info[:email])

    contact_details.click_button 'Add phone'
    expect(contact_details).to have_content('phone')

    client_info[:phone].split("").each do |digit|
      contact_details.find_field('phone').send_keys(digit)
    end

    formatted_phone = client_info[:phone].dup
    formatted_phone = formatted_phone.insert(0, '(')
                                     .insert(4, ')')
                                     .insert(5, ' ')
                                     .insert(9, '-')
    expect(contact_details).to have_field('phone', with: formatted_phone)

    @session.click_button('Continue')

    @session.find('button', text: 'Cancel').click
    @session.find('button', text: 'Cancel & Exit').click

    expect(@session).not_to have_content('Create client')

    expected_name = "%s %s" % [client_info[:firstName], client_info[:lastName]]

    @session.click_on('Clients')

    @session.find('.utility-bar').fill_in('utility-search', with: expected_name)
    # Added this sleep as expect fails to notice utility-search
    # was updated before its value is retrieved
    sleep 1
    expect(@session.find('.utility-bar')).to have_field('utility-search', with: expected_name)

    client_name = @session.first('.record-name').text

    expect(client_name).to eq(expected_name)
  end
end