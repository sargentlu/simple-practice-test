# frozen-string-literal: true

class ClientsPage
  include Capybara::DSL

  def search_client(first_name, last_name)
    client_name = "%s %s" % [first_name, last_name]
    client_properties = Hash.new

    click_on('Clients')

    find('.utility-bar').fill_in('utility-search', with: client_name)
    sleep 1

    client_properties['client_name'] = first('.record-name').text
    client_properties
  end
end
