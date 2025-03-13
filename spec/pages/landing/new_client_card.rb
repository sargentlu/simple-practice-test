# frozen-string-literal: true

class NewClientCard
  include Capybara::DSL

  def initialize(session)
    @session = session
  end

  def create_client(attrs)
    @session.click_on(class: 'button-link button-navbar create')
    @session.click_on('Create client')

    new_client = @session.find('.prospective-client-ui')

    new_client.fill_in('firstName', with: attrs[:firstName])
    new_client.fill_in('lastName', with: attrs[:lastName])

    new_client.fill_in('nickname', with: attrs[:nickname]) if attrs[:nickname]

    new_client.select attrs[:month], from: 'month' if attrs[:month]
    new_client.select attrs[:day], from: 'day' if attrs[:day]
    new_client.select attrs[:year], from: 'year' if attrs[:year]

    if attrs[:status] and attrs[:status].downcase.eql?('prospective')
      new_client.choose('Prospective', allow_label_click: true)
    end

    new_client.check('Add to waitlist', allow_label_click: true) if attrs[:waitlist]

    if attrs[:office] and new_client.find_field('office').text.include?(attrs[:office])
      new_client.select attrs[:office], from: 'office'
    end

    contact_details = new_client.find('.contact-details-section-container')

    if attrs[:email]
      contact_details.click_button 'Add email'
      contact_details.fill_in('email', with: attrs[:email])
    end

    if attrs[:phone]
      contact_details.click_button 'Add phone'
      contact_details.fill_in('phone', with: attrs[:phone])
    end

    new_client.click_button('Continue')
  end
end
